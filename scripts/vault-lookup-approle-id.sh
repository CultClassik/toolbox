#!/bin/sh
#
# vault-lookup-approle-id.sh
#

VAULT_TOKEN=$1
APPROLE_NAME=$2

req_url="${VAULT_ADDR}/v1/auth/approle/role/${APPROLE_NAME}/role-id"
ROLE_ID_RESPONSE=$(curl  \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request GET \
  --silent \
  "$req_url")

ROLE_ID=$(echo "$ROLE_ID_RESPONSE" | jq -r .data.role_id)

if [ "$ROLE_ID" = null ]; then
  echo "Result was null, exiting."
  exit 1
else
  echo "$ROLE_ID"
fi
