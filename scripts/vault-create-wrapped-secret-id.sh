#!/bin/sh
#
# vault-create-wrapped-secret-id.sh
#

VAULT_TOKEN=$1
APPROLE_NAME=$2

# Generate a wrapped response containing the secret id for the specified approle using the pipeline (trusted entity)
req_url="${VAULT_ADDR}/v1/auth/approle/role/${APPROLE_NAME}/secret-id"

WRAP_RESPONSE=$(curl  \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --header "X-Vault-Wrap-TTL: 500s" \
  --request POST \
  --silent \
  "$req_url")

WRAPPED_TOKEN=$(echo "$WRAP_RESPONSE" | jq -r .wrap_info.token)

if [ "$WRAPPED_TOKEN" = null ]; then
  echo "Result was null, exiting."
  exit 1
else
  echo "$WRAPPED_TOKEN"
fi
