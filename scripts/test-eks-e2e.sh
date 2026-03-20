#!/bin/bash
# ==============================================================================
# VibeVault EKS End-to-End Test Suite
# ==============================================================================
# Tests the full microservices platform deployed on EKS via Kong API Gateway.
# Verifies: health checks, OAuth2 auth, product CRUD, cart, order saga,
# Razorpay payment, webhook, notifications.
#
# Prerequisites:
#   - All 6 services deployed on EKS
#   - Kong API Gateway with www.vibesvault.live domain
#   - Razorpay webhook configured to https://www.vibesvault.live/payments/webhook/razorpay
#
# Usage:
#   ./scripts/test-eks-e2e.sh
#   TOKEN="xxx" ./scripts/test-eks-e2e.sh    # skip OAuth2 flow
#   NOTIFICATION_EMAIL="you@gmail.com" ./scripts/test-eks-e2e.sh  # use specific email
# ==============================================================================

set -euo pipefail

BASE_URL="https://www.vibesvault.live"

# Credentials — pass via env vars or fetch from AWS Secrets Manager
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@gmail.com}"
CLIENT_ID="${CLIENT_ID:-vibevault-client}"
REDIRECT_URI="https://oauth.pstmn.io/v1/callback"
SCOPES="openid+profile+email+read+write"

# Fetch secrets from AWS Secrets Manager if not provided
if [ -z "${ADMIN_PASSWORD:-}" ] || [ -z "${CLIENT_SECRET:-}" ]; then
    echo "Fetching credentials from AWS Secrets Manager..."
    APP_SECRETS=$(aws secretsmanager get-secret-value --secret-id "vibevault/dev/userservice/app-secrets" --query 'SecretString' --output text)
    ADMIN_PASSWORD="${ADMIN_PASSWORD:-$(echo "$APP_SECRETS" | python3 -c "import sys,json; print(json.load(sys.stdin)['ADMIN_PASSWORD'])")}"
    CLIENT_SECRET="${CLIENT_SECRET:-$(echo "$APP_SECRETS" | python3 -c "import sys,json; print(json.load(sys.stdin)['CLIENT_SECRET'])")}"
    echo "Credentials loaded from Secrets Manager"
fi

PASS=0
FAIL=0
SKIP=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# Helpers
# ============================================================================

assert_status() {
    local description="$1"
    local expected="$2"
    local actual="$3"
    local body="${4:-}"

    if [ "$actual" = "$expected" ]; then
        echo -e "  ${GREEN}PASS${NC} [$actual] $description"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}FAIL${NC} [$actual expected $expected] $description"
        [ -n "$body" ] && echo "       Response: $(echo "$body" | head -c 300)"
        FAIL=$((FAIL + 1))
    fi
}

assert_body_contains() {
    local description="$1"
    local expected_substring="$2"
    local body="$3"

    if echo "$body" | grep -qi "$expected_substring"; then
        echo -e "  ${GREEN}PASS${NC} $description (contains '$expected_substring')"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}FAIL${NC} $description (expected to contain '$expected_substring')"
        echo "       Response: $(echo "$body" | head -c 300)"
        FAIL=$((FAIL + 1))
    fi
}

request() {
    local method="$1"
    local url="$2"
    local headers="${3:-}"
    local data="${4:-}"

    local curl_args=(-s -w "\n%{http_code}" -X "$method" "$url")
    if [ -n "$headers" ]; then
        while IFS= read -r header; do
            [ -n "$header" ] && curl_args+=(-H "$header")
        done <<< "$headers"
    fi
    if [ -n "$data" ]; then
        curl_args+=(-d "$data")
    fi

    local response
    response=$(curl "${curl_args[@]}")
    BODY=$(echo "$response" | head -n -1)
    STATUS=$(echo "$response" | tail -n 1)
}

section() {
    echo ""
    echo -e "${CYAN}--- $1 ---${NC}"
}

urlencode() {
    python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$1"
}

# ============================================================================
# OAuth2 Token Flow
# ============================================================================

get_oauth2_token() {
    set +e
    local username="$1"
    local password="$2"

    local COOKIE_JAR
    COOKIE_JAR=$(mktemp /tmp/eks_test_cookies.XXXXXX)

    local OAUTH_URL="${BASE_URL}/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&scope=${SCOPES}"

    curl -s -c "$COOKIE_JAR" -b "$COOKIE_JAR" -L --max-redirs 1 -o /dev/null "$OAUTH_URL"

    local LOGIN_PAGE
    LOGIN_PAGE=$(curl -s -c "$COOKIE_JAR" -b "$COOKIE_JAR" "${BASE_URL}/login")
    local CSRF
    CSRF=$(echo "$LOGIN_PAGE" | grep -oP 'name="_csrf".*?value="\K[^"]+')

    if [ -z "$CSRF" ]; then
        rm -f "$COOKIE_JAR"
        set -e
        echo ""
        return
    fi

    local ENCODED_PASSWORD
    ENCODED_PASSWORD=$(urlencode "$password")
    curl -s -D- -o /dev/null -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "${BASE_URL}/login" \
        -d "username=${username}&password=${ENCODED_PASSWORD}&_csrf=${CSRF}" > /dev/null

    local AUTHORIZE_RESPONSE
    AUTHORIZE_RESPONSE=$(curl -s -D- -c "$COOKIE_JAR" -b "$COOKIE_JAR" \
        "${BASE_URL}/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&scope=${SCOPES}&continue")

    local AUTHORIZE_LOCATION
    AUTHORIZE_LOCATION=$(echo "$AUTHORIZE_RESPONSE" | grep -i "^Location:" | tr -d '\r' || true)

    local AUTH_CODE=""

    if echo "$AUTHORIZE_LOCATION" | grep -q "code="; then
        AUTH_CODE=$(echo "$AUTHORIZE_LOCATION" | grep -oP 'code=\K[^&\s]+' || true)
    else
        local CONSENT_BODY
        CONSENT_BODY=$(echo "$AUTHORIZE_RESPONSE" | sed '1,/^\r$/d')
        local STATE
        STATE=$(echo "$CONSENT_BODY" | grep -oP 'name="state"[^>]*value="\K[^"]+' || true)

        if [ -z "$STATE" ]; then
            rm -f "$COOKIE_JAR"
            set -e
            echo ""
            return
        fi

        local CONSENT_RESPONSE
        CONSENT_RESPONSE=$(curl -s -D- -o /dev/null -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "${BASE_URL}/oauth2/authorize" \
            -d "client_id=${CLIENT_ID}&state=${STATE}&scope=read&scope=profile&scope=write&scope=email")

        local CONSENT_LOCATION
        CONSENT_LOCATION=$(echo "$CONSENT_RESPONSE" | grep -i "^Location:" | tr -d '\r' || true)

        AUTH_CODE=$(echo "$CONSENT_LOCATION" | grep -oP 'code=\K[^&\s]+' || true)
    fi

    if [ -z "$AUTH_CODE" ]; then
        rm -f "$COOKIE_JAR"
        set -e
        echo ""
        return
    fi

    local TOKEN_RESPONSE
    TOKEN_RESPONSE=$(curl -s -X POST "${BASE_URL}/oauth2/token" \
        -u "${CLIENT_ID}:${CLIENT_SECRET}" \
        -d "grant_type=authorization_code" \
        -d "code=${AUTH_CODE}" \
        -d "redirect_uri=${REDIRECT_URI}")

    local TOKEN
    TOKEN=$(echo "$TOKEN_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])" 2>/dev/null || echo "")

    rm -f "$COOKIE_JAR"
    set -e
    echo "$TOKEN"
}

# ============================================================================
# Test Suite
# ============================================================================

echo "=============================================="
echo "  VibeVault EKS E2E Test Suite"
echo "  Platform: ${BASE_URL}"
echo "=============================================="

# --------------------------------------------------
section "1. Kong API Gateway + HTTPS"
# --------------------------------------------------

request GET "${BASE_URL}/auth/login"
if [ "$STATUS" != "000" ]; then
    echo -e "  ${GREEN}PASS${NC} Kong routing works (status: $STATUS)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} Cannot reach ${BASE_URL}"
    FAIL=$((FAIL + 1))
    echo "=============================================="
    printf "  Results: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}, ${YELLOW}%d skipped${NC}\n" "$PASS" "$FAIL" "$SKIP"
    echo "=============================================="
    exit 1
fi

# Webhook endpoint accessible without auth
request POST "${BASE_URL}/payments/webhook/razorpay" "Content-Type: application/json" '{"test":true}'
if [ "$STATUS" != "401" ]; then
    echo -e "  ${GREEN}PASS${NC} Webhook endpoint accessible without auth (status: $STATUS)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} Webhook returned 401"
    FAIL=$((FAIL + 1))
fi

# --------------------------------------------------
section "2. OAuth2 Authentication"
# --------------------------------------------------

if [ -n "${TOKEN:-}" ]; then
    echo -e "  ${GREEN}PASS${NC} Using provided TOKEN"
    PASS=$((PASS + 1))
else
    echo "  Obtaining admin OAuth2 token..."
    TOKEN=$(get_oauth2_token "$ADMIN_EMAIL" "$ADMIN_PASSWORD")
fi

if [[ "$TOKEN" =~ ^eyJ.*\..*\..*$ ]]; then
    echo -e "  ${GREEN}PASS${NC} Admin OAuth2 token obtained"
    PASS=$((PASS + 1))
    AUTH_HEADERS="$(printf 'Authorization: Bearer %s\nContent-Type: application/json' "$TOKEN")"
    AUTH_ONLY="Authorization: Bearer $TOKEN"
else
    echo -e "  ${RED}FAIL${NC} Could not obtain OAuth2 token"
    FAIL=$((FAIL + 1))
    echo ""
    echo "=============================================="
    printf "  Results: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}, ${YELLOW}%d skipped${NC}\n" "$PASS" "$FAIL" "$SKIP"
    echo "=============================================="
    exit 1
fi

# Unauthenticated request
request GET "${BASE_URL}/orders"
assert_status "Unauthenticated request → 401" "401" "$STATUS"

# --------------------------------------------------
section "3. Product Service"
# --------------------------------------------------

request POST "${BASE_URL}/categories" "$AUTH_HEADERS" '{"name":"Electronics","description":"Electronic devices"}'
if [ "$STATUS" = "200" ] || [ "$STATUS" = "409" ]; then
    echo -e "  ${GREEN}OK${NC} Category ready"
fi

TIMESTAMP=$(date +%s)
PRODUCT_NAME="EKS-Test-Product-${TIMESTAMP}"

request POST "${BASE_URL}/products" "$AUTH_HEADERS" \
    "{\"name\":\"${PRODUCT_NAME}\",\"description\":\"EKS E2E test product\",\"price\":499.99,\"currency\":\"INR\",\"categoryName\":\"Electronics\"}"
assert_status "POST /products (create)" "200" "$STATUS"
PRODUCT_ID=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")
echo -e "  ${CYAN}Product: ${PRODUCT_NAME} (${PRODUCT_ID})${NC}"

# --------------------------------------------------
section "4. Cart Service"
# --------------------------------------------------

curl -s -X DELETE "${BASE_URL}/cart" -H "$AUTH_ONLY" > /dev/null 2>&1
echo -e "  ${GREEN}OK${NC} Cart cleared"

request POST "${BASE_URL}/cart/items" "$AUTH_HEADERS" \
    "{\"productId\":\"${PRODUCT_ID}\",\"quantity\":2}"
assert_status "POST /cart/items (add product)" "201" "$STATUS"

request GET "${BASE_URL}/cart" "$AUTH_ONLY"
assert_status "GET /cart" "200" "$STATUS"
assert_body_contains "Cart has product" "$PRODUCT_ID" "$BODY"

# --------------------------------------------------
section "5. Checkout → Order → Payment (Saga)"
# --------------------------------------------------

request POST "${BASE_URL}/cart/checkout" "$AUTH_ONLY"
assert_status "POST /cart/checkout" "200" "$STATUS"

echo -e "  ${CYAN}Waiting for saga: cart → order → payment (Kafka)...${NC}"
sleep 10

# Verify order created
request GET "${BASE_URL}/orders" "$AUTH_ONLY"
assert_status "GET /orders" "200" "$STATUS"

ORDER_ID=$(echo "$BODY" | python3 -c "
import sys,json
data = json.load(sys.stdin)
orders = data.get('content', [])
if orders:
    print(orders[0]['orderId'])
else:
    print('')
" 2>/dev/null || echo "")

if [ -n "$ORDER_ID" ]; then
    echo -e "  ${CYAN}Order ID: ${ORDER_ID}${NC}"
    echo -e "  ${GREEN}PASS${NC} Order created via Kafka"
    PASS=$((PASS + 1))

    ORDER_STATUS=$(echo "$BODY" | python3 -c "
import sys,json
data = json.load(sys.stdin)
orders = data.get('content', [])
if orders: print(orders[0]['status'])
else: print('')
" 2>/dev/null || echo "")
    assert_body_contains "Order status PENDING" "PENDING" "$ORDER_STATUS"
else
    echo -e "  ${RED}FAIL${NC} No order created"
    FAIL=$((FAIL + 1))
fi

# Verify payment created
if [ -n "$ORDER_ID" ]; then
    request GET "${BASE_URL}/payments/order/${ORDER_ID}" "$AUTH_ONLY"
    assert_status "GET /payments/order/{orderId}" "200" "$STATUS"
    assert_body_contains "Payment PENDING" "PENDING" "$BODY"
    assert_body_contains "Payment gateway RAZORPAY" "RAZORPAY" "$BODY"

    PAYMENT_LINK=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('gatewayPaymentLink', ''))" 2>/dev/null || echo "")
    if [ -n "$PAYMENT_LINK" ]; then
        echo -e "  ${CYAN}Razorpay Link: ${PAYMENT_LINK}${NC}"
        echo -e "  ${GREEN}PASS${NC} Razorpay payment link generated"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}FAIL${NC} No payment link"
        FAIL=$((FAIL + 1))
    fi
fi

# --------------------------------------------------
section "6. Interactive Payment (Razorpay Test Mode)"
# --------------------------------------------------

if [ -n "$PAYMENT_LINK" ]; then
    echo ""
    echo -e "  ${YELLOW}═══════════════════════════════════════════════════${NC}"
    echo -e "  ${YELLOW}  Complete payment using Razorpay test mode:${NC}"
    echo -e "  ${YELLOW}  Link: ${PAYMENT_LINK}${NC}"
    echo -e "  ${YELLOW}  Card: 4111 1111 1111 1111${NC}"
    echo -e "  ${YELLOW}  Expiry: any future date | CVV: any 3 digits${NC}"
    echo -e "  ${YELLOW}═══════════════════════════════════════════════════${NC}"
    echo ""
    read -p "  Press ENTER after completing payment (or 's' to skip): " PAYMENT_CHOICE

    if [ "$PAYMENT_CHOICE" != "s" ] && [ "$PAYMENT_CHOICE" != "S" ]; then
        echo -e "  ${CYAN}Waiting for Razorpay webhook via Kong...${NC}"
        sleep 12

        # Verify payment CONFIRMED
        request GET "${BASE_URL}/payments/order/${ORDER_ID}" "$AUTH_ONLY"
        PAYMENT_STATUS=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('status', ''))" 2>/dev/null || echo "")

        if [ "$PAYMENT_STATUS" = "CONFIRMED" ]; then
            echo -e "  ${GREEN}PASS${NC} Payment CONFIRMED (webhook via Kong worked!)"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}FAIL${NC} Payment status: ${PAYMENT_STATUS} (expected CONFIRMED)"
            FAIL=$((FAIL + 1))
        fi

        # Verify order CONFIRMED
        request GET "${BASE_URL}/orders/${ORDER_ID}" "$AUTH_ONLY"
        ORDER_STATUS=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('status', ''))" 2>/dev/null || echo "")

        if [ "$ORDER_STATUS" = "CONFIRMED" ]; then
            echo -e "  ${GREEN}PASS${NC} Order CONFIRMED (full saga complete!)"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}FAIL${NC} Order status: ${ORDER_STATUS} (expected CONFIRMED)"
            FAIL=$((FAIL + 1))
        fi

        # Check notification logs
        echo -e "  ${CYAN}Checking notification service logs...${NC}"
        sleep 3
        NOTIF_LOGS=$(kubectl logs -l app=notificationservice -n vibevault --tail=200 2>/dev/null || echo "")

        if echo "$NOTIF_LOGS" | grep -q "Payment Successful"; then
            echo -e "  ${GREEN}PASS${NC} PAYMENT_CONFIRMED notification logged"
            PASS=$((PASS + 1))
        else
            echo -e "  ${YELLOW}WARN${NC} PAYMENT_CONFIRMED notification not found in logs (may need more time)"
        fi

        if echo "$NOTIF_LOGS" | grep -q "Order Confirmed"; then
            echo -e "  ${GREEN}PASS${NC} ORDER_CONFIRMED notification logged"
            PASS=$((PASS + 1))
        else
            echo -e "  ${YELLOW}WARN${NC} ORDER_CONFIRMED notification not found in logs"
        fi
    else
        echo -e "  ${YELLOW}SKIP${NC} Payment skipped"
        SKIP=$((SKIP + 4))
    fi
else
    echo -e "  ${YELLOW}SKIP${NC} No payment link"
    SKIP=$((SKIP + 4))
fi

# --------------------------------------------------
section "7. Error Handling"
# --------------------------------------------------

# Non-existent order
FAKE_ID="00000000-0000-0000-0000-000000000000"
request GET "${BASE_URL}/orders/${FAKE_ID}" "$AUTH_ONLY"
assert_status "GET non-existent order → 404" "404" "$STATUS"

# Malformed UUID
request GET "${BASE_URL}/orders/not-a-uuid" "$AUTH_ONLY"
assert_status "GET malformed UUID → 400" "400" "$STATUS"

# Non-existent payment
request GET "${BASE_URL}/payments/order/${FAKE_ID}" "$AUTH_ONLY"
assert_status "GET non-existent payment → 404" "404" "$STATUS"

# --------------------------------------------------
section "8. Platform Summary"
# --------------------------------------------------

echo -e "  ${CYAN}Platform: ${BASE_URL}${NC}"
echo -e "  ${CYAN}Services deployed on EKS:${NC}"
echo -e "  ${CYAN}  1. userservice — OAuth2 auth server${NC}"
echo -e "  ${CYAN}  2. productservice — product catalog${NC}"
echo -e "  ${CYAN}  3. cartservice — shopping cart (MongoDB Atlas)${NC}"
echo -e "  ${CYAN}  4. orderservice — order management + saga${NC}"
echo -e "  ${CYAN}  5. paymentgateway — Razorpay integration${NC}"
echo -e "  ${CYAN}  6. notificationservice — Console + SES email${NC}"
echo -e "  ${CYAN}  + Kong API Gateway with HTTPS (ACM cert)${NC}"
echo -e "  ${CYAN}  + Apache Kafka (KRaft single-node)${NC}"
echo -e "  ${CYAN}  + MySQL RDS${NC}"

# --------------------------------------------------
echo ""
echo "=============================================="
printf "  Results: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}, ${YELLOW}%d skipped${NC}\n" "$PASS" "$FAIL" "$SKIP"
echo "=============================================="

[ "$FAIL" -eq 0 ]
