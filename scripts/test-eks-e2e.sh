#!/bin/bash
# ==============================================================================
# VibeVault EKS End-to-End Test Suite (Comprehensive)
# ==============================================================================
# Tests the full microservices platform deployed on EKS via Kong API Gateway.
#
# Prerequisites:
#   - All 6 services deployed on EKS
#   - Kong API Gateway with www.vibesvault.live domain
#   - Razorpay webhook configured
#   - AWS CLI configured (for fetching secrets)
#
# Usage:
#   ./scripts/test-eks-e2e.sh
#   TOKEN="xxx" ./scripts/test-eks-e2e.sh    # skip OAuth2 flow
# ==============================================================================

set -euo pipefail

BASE_URL="https://www.vibesvault.live"

# Credentials — fetch from AWS Secrets Manager
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@gmail.com}"
CLIENT_ID="${CLIENT_ID:-vibevault-client}"
REDIRECT_URI="https://oauth.pstmn.io/v1/callback"
SCOPES="openid+profile+email+read+write"

if [ -z "${ADMIN_PASSWORD:-}" ] || [ -z "${CLIENT_SECRET:-}" ]; then
    echo "Fetching credentials from AWS Secrets Manager..."
    APP_SECRETS=$(aws secretsmanager get-secret-value --secret-id "vibevault/dev/userservice/app-secrets" --query 'SecretString' --output text)
    ADMIN_PASSWORD="${ADMIN_PASSWORD:-$(echo "$APP_SECRETS" | python3 -c "import sys,json; print(json.load(sys.stdin)['ADMIN_PASSWORD'])")}"
    CLIENT_SECRET="${CLIENT_SECRET:-$(echo "$APP_SECRETS" | python3 -c "import sys,json; print(json.load(sys.stdin)['CLIENT_SECRET'])")}"
    echo "Credentials loaded"
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

    local curl_args=(-s -m 15 -w "\n%{http_code}" -X "$method" "$url")
    if [ -n "$headers" ]; then
        while IFS= read -r header; do
            [ -n "$header" ] && curl_args+=(-H "$header")
        done <<< "$headers"
    fi
    if [ -n "$data" ]; then
        curl_args+=(-d "$data")
    fi

    local response
    response=$(curl "${curl_args[@]}" 2>/dev/null || echo -e "\n000")
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

    curl -s -m 15 -c "$COOKIE_JAR" -b "$COOKIE_JAR" -L --max-redirs 1 -o /dev/null "$OAUTH_URL"

    local LOGIN_PAGE
    LOGIN_PAGE=$(curl -s -m 15 -c "$COOKIE_JAR" -b "$COOKIE_JAR" "${BASE_URL}/login")
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
    curl -s -m 15 -D- -o /dev/null -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "${BASE_URL}/login" \
        -d "username=${username}&password=${ENCODED_PASSWORD}&_csrf=${CSRF}" > /dev/null

    local AUTHORIZE_RESPONSE
    AUTHORIZE_RESPONSE=$(curl -s -m 15 -D- -c "$COOKIE_JAR" -b "$COOKIE_JAR" \
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
        CONSENT_RESPONSE=$(curl -s -m 15 -D- -o /dev/null -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "${BASE_URL}/oauth2/authorize" \
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
    TOKEN_RESPONSE=$(curl -s -m 15 -X POST "${BASE_URL}/oauth2/token" \
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
echo "  VibeVault EKS E2E Test Suite (Comprehensive)"
echo "  Platform: ${BASE_URL}"
echo "=============================================="

# --------------------------------------------------
section "1. Kong API Gateway + HTTPS + Routing"
# --------------------------------------------------

# Test Kong is responding
request GET "${BASE_URL}/auth/login"
if [ "$STATUS" != "000" ]; then
    echo -e "  ${GREEN}PASS${NC} Kong HTTPS routing works (status: $STATUS)"
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
    echo -e "  ${GREEN}PASS${NC} Webhook permitAll (status: $STATUS)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} Webhook returned 401"
    FAIL=$((FAIL + 1))
fi

# Verify all Kong routes respond
for path in "/auth/login" "/products" "/cart" "/orders" "/payments/order/00000000-0000-0000-0000-000000000000"; do
    request GET "${BASE_URL}${path}"
    if [ "$STATUS" != "000" ] && [ "$STATUS" != "404" ] || [ "$STATUS" = "404" ]; then
        echo -e "  ${GREEN}PASS${NC} Route ${path} responds (status: $STATUS)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}FAIL${NC} Route ${path} unreachable"
        FAIL=$((FAIL + 1))
    fi
done

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

# Unauthenticated requests → 401
request GET "${BASE_URL}/orders"
assert_status "GET /orders (no token) → 401" "401" "$STATUS"

request GET "${BASE_URL}/cart"
assert_status "GET /cart (no token) → 401" "401" "$STATUS"

# --------------------------------------------------
section "3. Product Service — CRUD"
# --------------------------------------------------

# Create category
request POST "${BASE_URL}/categories" "$AUTH_HEADERS" '{"name":"Electronics","description":"Electronic devices"}'
if [ "$STATUS" = "200" ] || [ "$STATUS" = "409" ]; then
    echo -e "  ${GREEN}OK${NC} Category 'Electronics' ready"
fi

# Create product
TIMESTAMP=$(date +%s)
PRODUCT_NAME="EKS-Test-${TIMESTAMP}"

request POST "${BASE_URL}/products" "$AUTH_HEADERS" \
    "{\"name\":\"${PRODUCT_NAME}\",\"description\":\"EKS E2E test\",\"price\":499.99,\"currency\":\"INR\",\"categoryName\":\"Electronics\"}"
assert_status "POST /products (create)" "200" "$STATUS"
PRODUCT_ID=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")
echo -e "  ${CYAN}Product: ${PRODUCT_NAME} (${PRODUCT_ID})${NC}"

# Create second product
PRODUCT_NAME_2="EKS-Test2-${TIMESTAMP}"
request POST "${BASE_URL}/products" "$AUTH_HEADERS" \
    "{\"name\":\"${PRODUCT_NAME_2}\",\"description\":\"Second product\",\"price\":299.99,\"currency\":\"INR\",\"categoryName\":\"Electronics\"}"
assert_status "POST /products (create second)" "200" "$STATUS"
PRODUCT_ID_2=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")

# Get product by ID
request GET "${BASE_URL}/products/${PRODUCT_ID}" "$AUTH_ONLY"
assert_status "GET /products/{id}" "200" "$STATUS"
assert_body_contains "Product has correct name" "$PRODUCT_NAME" "$BODY"

# --------------------------------------------------
section "3b. Switch to Real User for Saga Flow"
# --------------------------------------------------

# Create CUSTOMER role + real user so notifications go to a real email
ADMIN_LOGIN_RESP=$(curl -s -m 15 -X POST "${BASE_URL}/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${ADMIN_EMAIL}\",\"password\":\"${ADMIN_PASSWORD}\"}")
ADMIN_JJWT=$(echo "$ADMIN_LOGIN_RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])" 2>/dev/null || echo "")

if [ -n "$ADMIN_JJWT" ]; then
    request POST "${BASE_URL}/roles/create" "$(printf 'Authorization: %s\nContent-Type: application/json' "$ADMIN_JJWT")" '{"roleName":"CUSTOMER","description":"Customer role"}'
    echo -e "  ${GREEN}OK${NC} CUSTOMER role ready"
fi

SAGA_EMAIL="${NOTIFICATION_EMAIL:-sparshraj90@gmail.com}"
SAGA_PASSWORD="Test@1234"
SAGA_PHONE="91$(date +%s | tail -c 9)"

request POST "${BASE_URL}/auth/signup" "Content-Type: application/json" \
    "{\"email\":\"${SAGA_EMAIL}\",\"password\":\"${SAGA_PASSWORD}\",\"name\":\"Sparsh Raj\",\"phone\":\"${SAGA_PHONE}\",\"role\":\"CUSTOMER\"}"
if [ "$STATUS" = "201" ] || [ "$STATUS" = "409" ] || [ "$STATUS" = "400" ]; then
    echo -e "  ${GREEN}OK${NC} Saga user ready (${SAGA_EMAIL})"
fi

echo "  Obtaining OAuth2 token for ${SAGA_EMAIL}..."
SAGA_TOKEN=$(get_oauth2_token "$SAGA_EMAIL" "$SAGA_PASSWORD")

if [[ "$SAGA_TOKEN" =~ ^eyJ.*\..*\..*$ ]]; then
    echo -e "  ${GREEN}PASS${NC} Saga user token obtained (${SAGA_EMAIL})"
    PASS=$((PASS + 1))
    # Switch to saga user for cart/order/payment flow
    AUTH_HEADERS="$(printf 'Authorization: Bearer %s\nContent-Type: application/json' "$SAGA_TOKEN")"
    AUTH_ONLY="Authorization: Bearer $SAGA_TOKEN"
    echo -e "  ${CYAN}Notifications will go to: ${SAGA_EMAIL}${NC}"
else
    echo -e "  ${YELLOW}WARN${NC} Could not get saga user token — continuing with admin"
fi

# --------------------------------------------------
section "4. Cart Service — CRUD + Edge Cases"
# --------------------------------------------------

# Clear cart
curl -s -m 15 -X DELETE "${BASE_URL}/cart" -H "$AUTH_ONLY" > /dev/null 2>&1
echo -e "  ${GREEN}OK${NC} Cart cleared"

# Add item
request POST "${BASE_URL}/cart/items" "$AUTH_HEADERS" \
    "{\"productId\":\"${PRODUCT_ID}\",\"quantity\":2}"
assert_status "POST /cart/items (add)" "201" "$STATUS"

# Add second item
request POST "${BASE_URL}/cart/items" "$AUTH_HEADERS" \
    "{\"productId\":\"${PRODUCT_ID_2}\",\"quantity\":1}"
assert_status "POST /cart/items (add second)" "201" "$STATUS"

# Get cart
request GET "${BASE_URL}/cart" "$AUTH_ONLY"
assert_status "GET /cart (with items)" "200" "$STATUS"
assert_body_contains "Cart has first product" "$PRODUCT_ID" "$BODY"
assert_body_contains "Cart has totalPrice" "totalPrice" "$BODY"

TOTAL_ITEMS=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('totalItems', 0))" 2>/dev/null || echo "0")
if [ "$TOTAL_ITEMS" -eq 3 ] 2>/dev/null; then
    echo -e "  ${GREEN}PASS${NC} Cart has 3 total items (2 + 1)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} Expected 3 items, got ${TOTAL_ITEMS}"
    FAIL=$((FAIL + 1))
fi

# Update quantity
request PATCH "${BASE_URL}/cart/items/${PRODUCT_ID}" "$AUTH_HEADERS" '{"quantity":5}'
assert_status "PATCH /cart/items/{id} (update to 5)" "200" "$STATUS"

# Remove item
request DELETE "${BASE_URL}/cart/items/${PRODUCT_ID_2}" "$AUTH_ONLY"
assert_status "DELETE /cart/items/{id} (remove)" "200" "$STATUS"

# Verify cart after remove
request GET "${BASE_URL}/cart" "$AUTH_ONLY"
ITEM_COUNT=$(echo "$BODY" | python3 -c "import sys,json; print(len(json.load(sys.stdin).get('items', [])))" 2>/dev/null || echo "-1")
if [ "$ITEM_COUNT" -eq 1 ] 2>/dev/null; then
    echo -e "  ${GREEN}PASS${NC} Cart has 1 item after remove"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} Expected 1 item, got ${ITEM_COUNT}"
    FAIL=$((FAIL + 1))
fi

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
    echo -e "  ${GREEN}PASS${NC} Order created via Kafka saga"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} No order created"
    FAIL=$((FAIL + 1))
fi

# Order has PENDING status
request GET "${BASE_URL}/orders/${ORDER_ID}" "$AUTH_ONLY"
assert_status "GET /orders/{id}" "200" "$STATUS"
assert_body_contains "Order PENDING" "PENDING" "$BODY"
assert_body_contains "Order has items" "items" "$BODY"

# Verify payment created
PAYMENT_LINK=""
if [ -n "$ORDER_ID" ]; then
    request GET "${BASE_URL}/payments/order/${ORDER_ID}" "$AUTH_ONLY"
    assert_status "GET /payments/order/{orderId}" "200" "$STATUS"
    assert_body_contains "Payment PENDING" "PENDING" "$BODY"
    assert_body_contains "Payment RAZORPAY" "RAZORPAY" "$BODY"

    PAYMENT_LINK=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('gatewayPaymentLink', ''))" 2>/dev/null || echo "")
    PAYMENT_AMOUNT=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('amount', 0))" 2>/dev/null || echo "0")
    if [ -n "$PAYMENT_LINK" ]; then
        echo -e "  ${CYAN}Razorpay Link: ${PAYMENT_LINK}${NC}"
        echo -e "  ${CYAN}Amount: ${PAYMENT_AMOUNT}${NC}"
        echo -e "  ${GREEN}PASS${NC} Razorpay payment link generated"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}FAIL${NC} No payment link"
        FAIL=$((FAIL + 1))
    fi
fi

# --------------------------------------------------
section "6. Idempotency — Second Checkout"
# --------------------------------------------------

# Add item and checkout again
request POST "${BASE_URL}/cart/items" "$AUTH_HEADERS" \
    "{\"productId\":\"${PRODUCT_ID}\",\"quantity\":1}"
request POST "${BASE_URL}/cart/checkout" "$AUTH_ONLY"
assert_status "POST /cart/checkout (second)" "200" "$STATUS"

echo -e "  ${CYAN}Waiting for Kafka...${NC}"
sleep 8

request GET "${BASE_URL}/orders" "$AUTH_ONLY"
ORDER_COUNT=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('totalElements', 0))" 2>/dev/null || echo "0")
if [ "$ORDER_COUNT" -ge 2 ] 2>/dev/null; then
    echo -e "  ${GREEN}PASS${NC} Second checkout created new order (${ORDER_COUNT} total)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} Expected at least 2 orders, got ${ORDER_COUNT}"
    FAIL=$((FAIL + 1))
fi

# --------------------------------------------------
section "7. Order Pagination"
# --------------------------------------------------

request GET "${BASE_URL}/orders?page=0&size=1" "$AUTH_ONLY"
assert_status "GET /orders?page=0&size=1" "200" "$STATUS"

PAGE_SIZE=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('size', 0))" 2>/dev/null || echo "0")
if [ "$PAGE_SIZE" -eq 1 ] 2>/dev/null; then
    echo -e "  ${GREEN}PASS${NC} Page size is 1"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} Expected page size 1, got ${PAGE_SIZE}"
    FAIL=$((FAIL + 1))
fi

TOTAL_PAGES=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('totalPages', 0))" 2>/dev/null || echo "0")
if [ "$TOTAL_PAGES" -ge 2 ] 2>/dev/null; then
    echo -e "  ${GREEN}PASS${NC} Multiple pages (${TOTAL_PAGES})"
    PASS=$((PASS + 1))
else
    echo -e "  ${YELLOW}WARN${NC} Expected multiple pages, got ${TOTAL_PAGES}"
fi

# --------------------------------------------------
section "8. Error Handling — All Services"
# --------------------------------------------------

FAKE_ID="00000000-0000-0000-0000-000000000000"

# Orders
request GET "${BASE_URL}/orders/${FAKE_ID}" "$AUTH_ONLY"
assert_status "GET /orders (non-existent) → 404" "404" "$STATUS"
assert_body_contains "ORDER_NOT_FOUND" "ORDER_NOT_FOUND" "$BODY"

request GET "${BASE_URL}/orders/not-a-uuid" "$AUTH_ONLY"
assert_status "GET /orders (malformed UUID) → 400" "400" "$STATUS"

# Payments
request GET "${BASE_URL}/payments/order/${FAKE_ID}" "$AUTH_ONLY"
assert_status "GET /payments (non-existent) → 404" "404" "$STATUS"
assert_body_contains "PAYMENT_NOT_FOUND" "PAYMENT_NOT_FOUND" "$BODY"

request GET "${BASE_URL}/payments/not-a-uuid" "$AUTH_ONLY"
assert_status "GET /payments (malformed UUID) → 400" "400" "$STATUS"

# Cart — checkout empty cart
curl -s -m 15 -X DELETE "${BASE_URL}/cart" -H "$AUTH_ONLY" > /dev/null 2>&1
request POST "${BASE_URL}/cart/checkout" "$AUTH_ONLY"
assert_status "POST /cart/checkout (empty) → 400" "400" "$STATUS"

# --------------------------------------------------
section "9. Order + Payment Isolation (Multi-User)"
# --------------------------------------------------

# Get admin JJWT to create roles/users
ADMIN_LOGIN_RESP=$(curl -s -m 15 -X POST "${BASE_URL}/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${ADMIN_EMAIL}\",\"password\":\"${ADMIN_PASSWORD}\"}")
ADMIN_JJWT=$(echo "$ADMIN_LOGIN_RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])" 2>/dev/null || echo "")

if [ -n "$ADMIN_JJWT" ]; then
    request POST "${BASE_URL}/roles/create" "$(printf 'Authorization: %s\nContent-Type: application/json' "$ADMIN_JJWT")" '{"roleName":"CUSTOMER","description":"Customer role"}'
    echo -e "  ${GREEN}OK${NC} CUSTOMER role ready"

    TIMESTAMP2=$(date +%s)
    USER_B_EMAIL="eks-user-b-${TIMESTAMP2}@test.com"
    PHONE_B="91${TIMESTAMP2: -8}"

    request POST "${BASE_URL}/auth/signup" "Content-Type: application/json" \
        "{\"email\":\"${USER_B_EMAIL}\",\"password\":\"Test@1234\",\"name\":\"User B\",\"phone\":\"${PHONE_B}\",\"role\":\"CUSTOMER\"}"
    if [ "$STATUS" = "201" ] || [ "$STATUS" = "409" ] || [ "$STATUS" = "400" ]; then
        echo -e "  ${GREEN}OK${NC} User B created (${USER_B_EMAIL})"
    fi

    echo "  Obtaining token for User B..."
    TOKEN_B=$(get_oauth2_token "$USER_B_EMAIL" "Test@1234")

    if [[ "$TOKEN_B" =~ ^eyJ.*\..*\..*$ ]]; then
        echo -e "  ${GREEN}PASS${NC} User B token obtained"
        PASS=$((PASS + 1))

        # User B can't see admin's orders
        request GET "${BASE_URL}/orders" "Authorization: Bearer $TOKEN_B"
        assert_status "User B: GET /orders" "200" "$STATUS"
        B_ORDER_COUNT=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('totalElements', -1))" 2>/dev/null || echo "-1")
        if [ "$B_ORDER_COUNT" -eq 0 ] 2>/dev/null; then
            echo -e "  ${GREEN}PASS${NC} User B sees 0 orders (isolated)"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}FAIL${NC} User B sees ${B_ORDER_COUNT} orders"
            FAIL=$((FAIL + 1))
        fi

        # User B can't access admin's order
        if [ -n "$ORDER_ID" ]; then
            request GET "${BASE_URL}/orders/${ORDER_ID}" "Authorization: Bearer $TOKEN_B"
            assert_status "User B: GET admin's order → 404" "404" "$STATUS"
        fi

        # User B can't access admin's payment
        if [ -n "$ORDER_ID" ]; then
            request GET "${BASE_URL}/payments/order/${ORDER_ID}" "Authorization: Bearer $TOKEN_B"
            assert_status "User B: GET admin's payment → 404" "404" "$STATUS"
        fi
    else
        echo -e "  ${YELLOW}SKIP${NC} Could not obtain User B token"
        SKIP=$((SKIP + 4))
    fi
else
    echo -e "  ${YELLOW}SKIP${NC} Could not get admin JJWT"
    SKIP=$((SKIP + 5))
fi

# --------------------------------------------------
section "10. Interactive Payment (Razorpay Test Mode)"
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

        # Payment CONFIRMED
        request GET "${BASE_URL}/payments/order/${ORDER_ID}" "$AUTH_ONLY"
        PAYMENT_STATUS=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('status', ''))" 2>/dev/null || echo "")
        if [ "$PAYMENT_STATUS" = "CONFIRMED" ]; then
            echo -e "  ${GREEN}PASS${NC} Payment CONFIRMED (webhook via Kong!)"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}FAIL${NC} Payment status: ${PAYMENT_STATUS}"
            FAIL=$((FAIL + 1))
        fi

        # Order CONFIRMED
        request GET "${BASE_URL}/orders/${ORDER_ID}" "$AUTH_ONLY"
        ORDER_STATUS=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('status', ''))" 2>/dev/null || echo "")
        if [ "$ORDER_STATUS" = "CONFIRMED" ]; then
            echo -e "  ${GREEN}PASS${NC} Order CONFIRMED (saga complete!)"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}FAIL${NC} Order status: ${ORDER_STATUS}"
            FAIL=$((FAIL + 1))
        fi

        # Notification logs
        sleep 3
        NOTIF_LOGS=$(kubectl logs -l app=notificationservice -n vibevault --tail=200 2>/dev/null || echo "")
        if echo "$NOTIF_LOGS" | grep -q "Payment Successful"; then
            echo -e "  ${GREEN}PASS${NC} Payment notification logged"
            PASS=$((PASS + 1))
        else
            echo -e "  ${YELLOW}WARN${NC} Payment notification not found in logs"
        fi
        if echo "$NOTIF_LOGS" | grep -q "Order Confirmed"; then
            echo -e "  ${GREEN}PASS${NC} Order confirmed notification logged"
            PASS=$((PASS + 1))
        else
            echo -e "  ${YELLOW}WARN${NC} Order confirmed notification not found"
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
section "11. Platform Summary"
# --------------------------------------------------

echo -e "  ${CYAN}Platform: ${BASE_URL}${NC}"
echo -e "  ${CYAN}Services:${NC}"
echo -e "  ${CYAN}  1. userservice — OAuth2 auth server${NC}"
echo -e "  ${CYAN}  2. productservice — product catalog${NC}"
echo -e "  ${CYAN}  3. cartservice — shopping cart (MongoDB Atlas)${NC}"
echo -e "  ${CYAN}  4. orderservice — order management + saga${NC}"
echo -e "  ${CYAN}  5. paymentgateway — Razorpay integration${NC}"
echo -e "  ${CYAN}  6. notificationservice — Console + SES email${NC}"
echo -e "  ${CYAN}  + Kong API Gateway (HTTPS via ACM)${NC}"
echo -e "  ${CYAN}  + Kafka (KRaft), MySQL RDS, MongoDB Atlas${NC}"

# --------------------------------------------------
echo ""
echo "=============================================="
printf "  Results: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}, ${YELLOW}%d skipped${NC}\n" "$PASS" "$FAIL" "$SKIP"
echo "=============================================="

[ "$FAIL" -eq 0 ]
