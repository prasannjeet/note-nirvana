#!/bin/bash

# The NEW_URL is received as the first argument
NEW_URL=$1

# Keycloak configuration variables
KEYCLOAK_SERVER="https://keycloak.ooguy.com"
REALM="timetable-oauth"
CLIENT_ID="note-nirvana"
AUTH_CLIENT_ID="admin-client-permanent"
AUTH_CLIENT_SECRET="vXBOorXc0BXkbD9rY8SQYrKcqTt78zQu"

# Redirect URIs, Post Logout Redirect URIs, and Web Origins to add
NEW_REDIRECT_URIS=("${NEW_URL}")
NEW_POST_LOGOUT_REDIRECT_URIS=("${NEW_URL}")
NEW_WEB_ORIGINS=("${NEW_URL}") 

# Obtain access token
ACCESS_TOKEN=$(curl -s -X POST "${KEYCLOAK_SERVER}/realms/${REALM}/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=${AUTH_CLIENT_ID}" \
  -d "client_secret=${AUTH_CLIENT_SECRET}" \
  -d "grant_type=client_credentials" | jq -r '.access_token')

# Get client configuration
CLIENT_CONFIG=$(curl -s -X GET "${KEYCLOAK_SERVER}/admin/realms/${REALM}/clients?clientId=${CLIENT_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

# Update client configuration with new Redirect URIs, Post Logout Redirect URIs, and Web Origins
UPDATED_CLIENT_CONFIG=$(echo "${CLIENT_CONFIG}" \
  | jq --argjson newRedirectUris "$(echo "${NEW_REDIRECT_URIS[@]}" | jq -R . | jq -s .)" \
        --argjson newPostLogoutRedirectUris "$(echo "${NEW_POST_LOGOUT_REDIRECT_URIS[@]}" | jq -R . | jq -s .)" \
        --argjson newWebOrigins "$(echo "${NEW_WEB_ORIGINS[@]}" | jq -R . | jq -s .)" \
  '.[0] | . + {redirectUris: (.redirectUris + $newRedirectUris), webOrigins: (.webOrigins + $newWebOrigins)} | .attributes."post.logout.redirect.uris" = (.attributes."post.logout.redirect.uris" + "##" + ([$newPostLogoutRedirectUris[]] | join("##")))')

echo $UPDATED_CLIENT_CONFIG

# Extract the internal ID from the client configuration
INTERNAL_ID=$(echo "${CLIENT_CONFIG}" | jq -r '.[0].id')

# Save the updated client configuration
curl -X PUT "${KEYCLOAK_SERVER}/admin/realms/${REALM}/clients/${INTERNAL_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${UPDATED_CLIENT_CONFIG}"
