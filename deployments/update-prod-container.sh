#!/bin/bash

# Set your API token and endpoint ID
ACCESS_TOKEN="ptr_p/M/RUULBXG/IRsZETprere96rPrS+rY1mmV1HnShL4="
ENDPOINT_ID="4"
STACK_NAME="notenirvana-production"

# Set the base URL for the Portainer API
PORTAINER_API_BASE="https://portainerbe.1cooldns.com/api"

# Get the stack ID using the stack name
PAYLOAD=$(curl -s -H "X-API-Key: ${ACCESS_TOKEN}" "${PORTAINER_API_BASE}/stacks")
# Extract the stack ID from the payload
STACK_ID=$(echo "$PAYLOAD" | jq -r ".[] | select(.Name==\"${STACK_NAME}\") | .Id")
ENV_VARIABLES=$(echo "$PAYLOAD" | jq -r ".[] | select(.Name==\"${STACK_NAME}\") | .Env")

# Get the stack file content and env variables
STACK_DETAILS=$(curl -s -H "X-API-Key: ${ACCESS_TOKEN}" "${PORTAINER_API_BASE}/stacks/${STACK_ID}/file")
STACK_FILE_CONTENT=$(echo "${STACK_DETAILS}" | jq -r '.StackFileContent')

update_image() {
  SERVICE_NAME="$1"
  NEW_IMAGE="$2"

  # Update the image in the stack file content using environment variables
  STACK_FILE_CONTENT=$(YQ_SERVICE_NAME="${SERVICE_NAME}" YQ_NEW_IMAGE="${NEW_IMAGE}" yq e '.services[env(YQ_SERVICE_NAME)].image = env(YQ_NEW_IMAGE)' - <<< "${STACK_FILE_CONTENT}")
}

# Loop through the arguments as pairs (service name and new image)
while [ "$#" -gt 0 ]; do
  SERVICE_NAME="$1"
  NEW_IMAGE="$2"
  update_image "$SERVICE_NAME" "$NEW_IMAGE"
  shift 2
done

# Update the stack with the modified stack file content and saved environment variables
ENCODED_STACK_FILE_CONTENT=$(echo -n "${STACK_FILE_CONTENT}" | jq -sRr @json)
curl -X PUT -H "X-API-Key: ${ACCESS_TOKEN}" -H "Content-Type: application/json" -d "{\"StackFileContent\": ${ENCODED_STACK_FILE_CONTENT}, \"Env\": ${ENV_VARIABLES}}" "${PORTAINER_API_BASE}/stacks/${STACK_ID}?endpointId=${ENDPOINT_ID}"
