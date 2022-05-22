#!/bin/bash
#
# vault-tfe-token.sh
#
# Request a new TFE API token using Vault role $VAULT_ROLE_NAME
# Must authenticate with Vault before running script.

VAULT_TOKEN=$1
VAULT_ROLE_NAME=$2

req_url="${VAULT_ADDR}/v1/terraform/creds/${VAULT_ROLE_NAME}"

ROLE_ID_RESPONSE=$(curl  \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request GET \
  --silent \
  "$req_url")

tfe_token=$(echo "$ROLE_ID_RESPONSE" | jq -r .data.token)

if [ "$ROLE_ID" = null ]; then
  echo "Result was null, exiting."
  exit 1
else
  echo "$tfe_token"
fi
