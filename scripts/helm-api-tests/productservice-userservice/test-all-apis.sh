#!/bin/bash
# ==============================================================================
# VibeVault API Test Suite
# ==============================================================================
# Tests all userservice and productservice endpoints.
# OAuth2 token is obtained automatically (no browser needed).
#
# Prerequisites:
#   - userservice port-forwarded to localhost:8081
#   - productservice port-forwarded to localhost:8080
#   - userservice scaled to 1 replica (RSA key consistency)
#
# Usage:
#   ./test-all-apis.sh              # runs all tests (auto OAuth2)
#   TOKEN="xxx" ./test-all-apis.sh  # skip OAuth2 flow, use provided token
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERSERVICE="http://localhost:8081"
PRODUCTSERVICE="http://localhost:8080"
PASS=0
FAIL=0
SKIP=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

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
        [ -n "$body" ] && echo "       Response: $body"
        FAIL=$((FAIL + 1))
    fi
}

skip_test() {
    echo -e "  ${YELLOW}SKIP${NC} $1"
    SKIP=$((SKIP + 1))
}

# Helper: make request and capture status + body
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

echo "=============================================="
echo "  VibeVault API Test Suite"
echo "=============================================="
echo ""

# --------------------------------------------------
echo "--- Health Checks ---"
# --------------------------------------------------
request GET "$USERSERVICE/actuator/health"
assert_status "userservice health" "200" "$STATUS"

request GET "$PRODUCTSERVICE/actuator/health"
assert_status "productservice health" "200" "$STATUS"

# --------------------------------------------------
echo ""
echo "--- Userservice: Auth APIs ---"
# --------------------------------------------------

# Login as admin
request POST "$USERSERVICE/auth/login" "Content-Type: application/json" '{"email":"admin@gmail.com","password":"abcd@1234"}'
assert_status "POST /auth/login (admin)" "200" "$STATUS"
ADMIN_TOKEN=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])" 2>/dev/null || echo "")

# Validate token
if [ -n "$ADMIN_TOKEN" ]; then
    request POST "$USERSERVICE/auth/validate" "Authorization: $ADMIN_TOKEN"
    assert_status "POST /auth/validate" "200" "$STATUS"
else
    skip_test "POST /auth/validate (no token)"
fi

# --------------------------------------------------
echo ""
echo "--- Userservice: Role APIs ---"
# --------------------------------------------------

if [ -n "$ADMIN_TOKEN" ]; then
    # Get all roles
    request GET "$USERSERVICE/roles" "Authorization: $ADMIN_TOKEN"
    assert_status "GET /roles" "200" "$STATUS"

    # Check if CUSTOMER and SELLER roles exist, create if not
    EXISTING_ROLES="$BODY"
    if ! echo "$EXISTING_ROLES" | python3 -c "import sys,json; roles=[r['roleName'] for r in json.load(sys.stdin)]; sys.exit(0 if 'CUSTOMER' in roles else 1)" 2>/dev/null; then
        request POST "$USERSERVICE/roles/create" "$(printf 'Authorization: %s\nContent-Type: application/json' "$ADMIN_TOKEN")" '{"roleName":"CUSTOMER","description":"Customer role"}'
        assert_status "POST /roles/create (CUSTOMER)" "201" "$STATUS"
    else
        echo -e "  ${GREEN}PASS${NC} [exists] CUSTOMER role already exists"
        PASS=$((PASS + 1))
    fi

    if ! echo "$EXISTING_ROLES" | python3 -c "import sys,json; roles=[r['roleName'] for r in json.load(sys.stdin)]; sys.exit(0 if 'SELLER' in roles else 1)" 2>/dev/null; then
        request POST "$USERSERVICE/roles/create" "$(printf 'Authorization: %s\nContent-Type: application/json' "$ADMIN_TOKEN")" '{"roleName":"SELLER","description":"Seller role"}'
        assert_status "POST /roles/create (SELLER)" "201" "$STATUS"
    else
        echo -e "  ${GREEN}PASS${NC} [exists] SELLER role already exists"
        PASS=$((PASS + 1))
    fi

    # Get all roles again to find IDs
    request GET "$USERSERVICE/roles" "Authorization: $ADMIN_TOKEN"
    ROLE_ID=$(echo "$BODY" | python3 -c "import sys,json; roles=json.load(sys.stdin); print(next(r['roleId'] for r in roles if r['roleName']=='CUSTOMER'))" 2>/dev/null || echo "")

    # Get role by ID
    if [ -n "$ROLE_ID" ]; then
        request GET "$USERSERVICE/roles/$ROLE_ID" "Authorization: $ADMIN_TOKEN"
        assert_status "GET /roles/{roleId}" "200" "$STATUS"

        # Update role
        request POST "$USERSERVICE/roles/update/$ROLE_ID" "$(printf 'Authorization: %s\nContent-Type: application/json' "$ADMIN_TOKEN")" '{"roleName":"CUSTOMER","description":"Customer role (updated)"}'
        assert_status "POST /roles/update/{roleId}" "200" "$STATUS"
    else
        skip_test "GET /roles/{roleId} (no role ID)"
        skip_test "POST /roles/update/{roleId} (no role ID)"
    fi
else
    skip_test "All role APIs (no admin token)"
fi

# --------------------------------------------------
echo ""
echo "--- Userservice: Signup & Login ---"
# --------------------------------------------------

# Signup seller (may already exist)
request POST "$USERSERVICE/auth/signup" "Content-Type: application/json" '{"email":"seller@gmail.com","password":"sell@1234","name":"Test Seller","phone":"9876543211","role":"SELLER"}'
if [ "$STATUS" = "201" ] || [ "$STATUS" = "409" ] || [ "$STATUS" = "400" ]; then
    assert_status "POST /auth/signup (SELLER)" "$STATUS" "$STATUS"
else
    assert_status "POST /auth/signup (SELLER)" "201" "$STATUS" "$BODY"
fi

# Login seller
request POST "$USERSERVICE/auth/login" "Content-Type: application/json" '{"email":"seller@gmail.com","password":"sell@1234"}'
assert_status "POST /auth/login (seller)" "200" "$STATUS"

# Logout
SELLER_CUSTOM_TOKEN=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])" 2>/dev/null || echo "")
if [ -n "$SELLER_CUSTOM_TOKEN" ]; then
    request POST "$USERSERVICE/auth/logout" "Content-Type: application/json" "{\"userEmail\":\"seller@gmail.com\",\"token\":\"$SELLER_CUSTOM_TOKEN\"}"
    assert_status "POST /auth/logout" "204" "$STATUS"
else
    skip_test "POST /auth/logout (no token)"
fi

# --------------------------------------------------
echo ""
echo "--- Productservice: Authenticated APIs (OAuth2) ---"
# --------------------------------------------------

# Get OAuth2 token if not provided
if [ -z "${TOKEN:-}" ]; then
    echo ""
    echo "  Obtaining OAuth2 token automatically..."

    TOKEN_OUTPUT=$("$SCRIPT_DIR/get-oauth2-token.sh" admin@gmail.com abcd@1234 2>&1) || true
    TOKEN=$(echo "$TOKEN_OUTPUT" | tail -1)

    # Verify it looks like a JWT (3 dot-separated parts)
    if [[ "$TOKEN" =~ ^eyJ.*\..*\..*$ ]]; then
        ROLES=$(echo "$TOKEN_OUTPUT" | grep "Roles:" | head -1 || echo "")
        echo -e "  ${GREEN}Token obtained${NC} ${ROLES}"
    else
        echo -e "  ${RED}Failed to get OAuth2 token${NC}"
        echo "  Output: $(echo "$TOKEN_OUTPUT" | tail -5)"
        TOKEN=""
        skip_test "All authenticated productservice endpoints"
    fi
fi

if [ -n "${TOKEN:-}" ]; then
    AUTH_HEADERS="$(printf 'Authorization: Bearer %s\nContent-Type: application/json' "$TOKEN")"

    # Create category (ensures category data exists for GET tests below)
    request POST "$PRODUCTSERVICE/categories" "$AUTH_HEADERS" '{"name":"Electronics","description":"Electronic devices and gadgets"}'
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "409" ]; then
        assert_status "POST /categories (create Electronics)" "$STATUS" "$STATUS"
    else
        assert_status "POST /categories (create Electronics)" "200" "$STATUS" "$BODY"
    fi

    request POST "$PRODUCTSERVICE/categories" "$AUTH_HEADERS" '{"name":"Books","description":"Books and reading materials"}'
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "409" ]; then
        assert_status "POST /categories (create Books)" "$STATUS" "$STATUS"
    else
        assert_status "POST /categories (create Books)" "200" "$STATUS" "$BODY"
    fi

    # Create two products (unique names to avoid duplicate constraint)
    # First product stays in DB for GET tests later; second is used for PATCH/PUT/DELETE
    TIMESTAMP=$(date +%s)
    request POST "$PRODUCTSERVICE/products" "$AUTH_HEADERS" "{\"name\":\"Seed-Product-${TIMESTAMP}\",\"description\":\"A seed product for GET tests\",\"imageUrl\":\"http://example.com/seed.jpg\",\"price\":499.99,\"currency\":\"INR\",\"categoryName\":\"Electronics\"}"
    assert_status "POST /products (create seed)" "200" "$STATUS"

    TEST_PRODUCT_NAME="Test-Product-${TIMESTAMP}"
    request POST "$PRODUCTSERVICE/products" "$AUTH_HEADERS" "{\"name\":\"${TEST_PRODUCT_NAME}\",\"description\":\"A test laptop\",\"imageUrl\":\"http://example.com/laptop.jpg\",\"price\":1299.99,\"currency\":\"INR\",\"categoryName\":\"Electronics\"}"
    assert_status "POST /products (create)" "200" "$STATUS"
    NEW_PRODUCT_ID=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")

    if [ -n "$NEW_PRODUCT_ID" ]; then
        # Update product (PATCH)
        request PATCH "$PRODUCTSERVICE/products/$NEW_PRODUCT_ID" "$AUTH_HEADERS" "{\"name\":\"${TEST_PRODUCT_NAME}-patched\"}"
        assert_status "PATCH /products/{id} (update)" "200" "$STATUS"

        # Replace product (PUT)
        request PUT "$PRODUCTSERVICE/products/$NEW_PRODUCT_ID" "$AUTH_HEADERS" "{\"name\":\"${TEST_PRODUCT_NAME}-replaced\",\"description\":\"An ultra laptop\",\"imageUrl\":\"http://example.com/ultra.jpg\",\"price\":1599.99,\"currency\":\"USD\",\"categoryName\":\"Electronics\"}"
        assert_status "PUT /products/{id} (replace)" "200" "$STATUS"

        # Delete product
        request DELETE "$PRODUCTSERVICE/products/$NEW_PRODUCT_ID" "Authorization: Bearer $TOKEN"
        assert_status "DELETE /products/{id}" "200" "$STATUS"
    else
        skip_test "PATCH /products/{id} (no product created)"
        skip_test "PUT /products/{id} (no product created)"
        skip_test "DELETE /products/{id} (no product created)"
    fi
fi

# --------------------------------------------------
echo ""
echo "--- Productservice: Public GET APIs ---"
# --------------------------------------------------

request GET "$PRODUCTSERVICE/products"
assert_status "GET /products" "200" "$STATUS"

# Extract first product ID and category info
PRODUCT_ID=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['id'])" 2>/dev/null || echo "")
CATEGORY_NAME=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['categoryName'])" 2>/dev/null || echo "Electronics")

if [ -n "$PRODUCT_ID" ]; then
    request GET "$PRODUCTSERVICE/products/$PRODUCT_ID"
    assert_status "GET /products/{id}" "200" "$STATUS"
else
    skip_test "GET /products/{id} (no product)"
fi

request GET "$PRODUCTSERVICE/categories"
assert_status "GET /categories" "200" "$STATUS"

CATEGORY_ID=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['id'])" 2>/dev/null || echo "")

if [ -n "$CATEGORY_ID" ]; then
    request GET "$PRODUCTSERVICE/categories/id/$CATEGORY_ID"
    assert_status "GET /categories/id/{id}" "200" "$STATUS"
fi

request GET "$PRODUCTSERVICE/categories/name/$CATEGORY_NAME"
assert_status "GET /categories/name/{name}" "200" "$STATUS"

request GET "$PRODUCTSERVICE/categories/products/$CATEGORY_NAME"
assert_status "GET /categories/products/{name}" "200" "$STATUS"

if [ -n "$CATEGORY_ID" ]; then
    request GET "$PRODUCTSERVICE/categories/products?categoryUuid=$CATEGORY_ID"
    assert_status "GET /categories/products?categoryUuid=" "200" "$STATUS"
fi

request GET "$PRODUCTSERVICE/search/products?page=0&size=10"
assert_status "GET /search/products" "200" "$STATUS"

request GET "$PRODUCTSERVICE/search/products?query=$TEST_PRODUCT_NAME&page=0&size=10"
assert_status "GET /search/products?query=" "200" "$STATUS"

request GET "$PRODUCTSERVICE/search/products/suggest?prefix=${TEST_PRODUCT_NAME:0:4}&limit=5"
assert_status "GET /search/products/suggest" "200" "$STATUS"

# --------------------------------------------------
echo ""
echo "=============================================="
printf "  Results: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}, ${YELLOW}%d skipped${NC}\n" "$PASS" "$FAIL" "$SKIP"
echo "=============================================="
