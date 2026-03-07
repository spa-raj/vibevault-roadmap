#!/bin/bash
# ==============================================================================
# OAuth2 Authorization Code Flow - Automated Token Generator
# ==============================================================================
# Fully automated: logs in via form, consents to scopes, exchanges code for
# token. No browser interaction needed.
#
# Prerequisites:
#   - userservice running and port-forwarded to localhost:8081
#   - User account exists (admin@gmail.com / abcd@1234 is seeded by default)
#
# Usage:
#   ./get-oauth2-token.sh                                          # admin token
#   ./get-oauth2-token.sh seller@gmail.com sell@1234               # seller token
#   ./get-oauth2-token.sh admin@gmail.com abcd@1234 8081           # custom port
#   source ./get-oauth2-token.sh                                   # exports TOKEN
# ==============================================================================

set -euo pipefail

USERNAME="${1:-admin@gmail.com}"
PASSWORD="${2:-abcd@1234}"
USERSERVICE_PORT="${3:-8081}"
USERSERVICE_URL="http://localhost:${USERSERVICE_PORT}"
CLIENT_ID="vibevault-client"
CLIENT_SECRET="abc@12345"
REDIRECT_URI="https://oauth.pstmn.io/v1/callback"
SCOPES="openid+profile+email+read+write"
COOKIE_JAR=$(mktemp /tmp/oauth2_cookies.XXXXXX)

cleanup() { rm -f "$COOKIE_JAR"; }
trap cleanup EXIT

AUTH_URL="${USERSERVICE_URL}/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&scope=${SCOPES}"

echo "=============================================="
echo "  OAuth2 Automated Token Flow"
echo "=============================================="
echo "  User:     ${USERNAME}"
echo "  Issuer:   ${USERSERVICE_URL}"
echo ""

# Step 1: Hit authorize → redirects to /login (establishes session)
curl -s -c "$COOKIE_JAR" -b "$COOKIE_JAR" -L --max-redirs 1 -o /dev/null "$AUTH_URL"

# Step 2: Get login page → extract CSRF token
LOGIN_PAGE=$(curl -s -c "$COOKIE_JAR" -b "$COOKIE_JAR" "${USERSERVICE_URL}/login")
CSRF=$(echo "$LOGIN_PAGE" | grep -oP 'name="_csrf".*?value="\K[^"]+')

if [ -z "$CSRF" ]; then
    echo "Error: Could not extract CSRF token from login page."
    exit 1
fi

# Step 3: POST login with credentials
LOGIN_RESPONSE=$(curl -s -D- -o /dev/null -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "${USERSERVICE_URL}/login" \
    -d "username=${USERNAME}&password=${PASSWORD}&_csrf=${CSRF}")

LOGIN_LOCATION=$(echo "$LOGIN_RESPONSE" | grep -i "^Location:" | tr -d '\r')

if echo "$LOGIN_LOCATION" | grep -q "error"; then
    echo "Error: Login failed. Check credentials."
    exit 1
fi

echo "  [1/4] Login successful"

# Step 4: Follow redirect back to /oauth2/authorize → get consent page or code
AUTHORIZE_RESPONSE=$(curl -s -D- -c "$COOKIE_JAR" -b "$COOKIE_JAR" "${USERSERVICE_URL}/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&scope=${SCOPES}&continue")

AUTHORIZE_LOCATION=$(echo "$AUTHORIZE_RESPONSE" | grep -i "^Location:" | tr -d '\r')

# Check if we got redirected directly to callback (consent already given)
if echo "$AUTHORIZE_LOCATION" | grep -q "code="; then
    AUTH_CODE=$(echo "$AUTHORIZE_LOCATION" | grep -oP 'code=\K[^&]+')
    echo "  [2/4] Consent already granted (reused)"
else
    # Need to submit consent form
    CONSENT_BODY=$(echo "$AUTHORIZE_RESPONSE" | sed '1,/^\r$/d')
    STATE=$(echo "$CONSENT_BODY" | grep -oP 'name="state".*?value="\K[^"]+')

    if [ -z "$STATE" ]; then
        echo "Error: Could not extract state from consent page."
        exit 1
    fi

    echo "  [2/4] Submitting consent"

    # POST consent with all scopes
    CONSENT_RESPONSE=$(curl -s -D- -o /dev/null -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "${USERSERVICE_URL}/oauth2/authorize" \
        -d "client_id=${CLIENT_ID}&state=${STATE}&scope=read&scope=profile&scope=write&scope=email")

    CONSENT_LOCATION=$(echo "$CONSENT_RESPONSE" | grep -i "^Location:" | tr -d '\r')

    if ! echo "$CONSENT_LOCATION" | grep -q "code="; then
        echo "Error: Consent submission did not return authorization code."
        echo "  Location: ${CONSENT_LOCATION}"
        exit 1
    fi

    AUTH_CODE=$(echo "$CONSENT_LOCATION" | grep -oP 'code=\K[^&]+')
fi

echo "  [3/4] Authorization code obtained"

# Step 5: Exchange authorization code for access token
RESPONSE=$(curl -s -X POST "${USERSERVICE_URL}/oauth2/token" \
    -u "${CLIENT_ID}:${CLIENT_SECRET}" \
    -d "grant_type=authorization_code" \
    -d "code=${AUTH_CODE}" \
    -d "redirect_uri=${REDIRECT_URI}")

if ! echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); sys.exit(0 if 'access_token' in d else 1)" 2>/dev/null; then
    echo "Error: Token exchange failed."
    echo "  Response: ${RESPONSE}"
    exit 1
fi

ACCESS_TOKEN=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")
EXPIRES_IN=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('expires_in','unknown'))")
ROLES=$(echo "$ACCESS_TOKEN" | python3 -c "
import sys,json,base64
token=sys.stdin.read().strip()
payload=token.split('.')[1]
payload+='='*(-len(payload)%4)
claims=json.loads(base64.urlsafe_b64decode(payload))
print(claims.get('roles',[]))
" 2>/dev/null || echo "unknown")

echo "  [4/4] Token exchange successful"
echo ""
echo "=============================================="
echo "  Roles:      ${ROLES}"
echo "  Expires in: ${EXPIRES_IN}s"
echo "=============================================="
echo ""
echo "${ACCESS_TOKEN}"

# Export for use with 'source'
export TOKEN="${ACCESS_TOKEN}"
