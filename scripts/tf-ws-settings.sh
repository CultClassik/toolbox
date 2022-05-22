#!/bin/sh
#
# tf-ws-settings.sh
#

TF_TOKEN=$1
TFE_WS_NAME=$2
TF_URL=""

generate_post_data() {
cat <<EOF
{
  "data": {
    "type": "workspaces",
    "attributes": {
      "name": "${TFE_WS_NAME}",
      "execution-mode": "${TFE_EXEC_MODE}",
      "terraform_version": "${TF_VERSION}",
      "working-directory": "${WORKSPACE_RUN_DIR}"
    }
  }
}
EOF
}

echo "Setting workspace options for workspace: ${TFE_WS_NAME}"
echo "TFE API URL: ${TF_URL}"
echo "Payload:"
# shellcheck disable=SC2005
echo "$(generate_post_data)" | jq -C .

# shellcheck disable=SC2005
RESULT=$(curl \
  --silent \
  -H "Content-Type: application/vnd.api+json" \
  -H "Authorization: Bearer ${TF_TOKEN}" \
  --request PATCH \
  --data "$(generate_post_data)" \
  "$TF_URL")

echo "raw RESULT: ${RESULT}"

echo "$RESULT" | jq -C .

if [ -n "${RESULT}" ]; then
  ERROR=$(echo "$RESULT" | jq .errors)
  WS_ID=$(echo "$RESULT" | jq .data.id)
  if [ "$ERROR" != null ]; then
    echo "$ERROR" | jq
    exit 1
  elif [ "$WS_ID" = null ]; then
    "Possible non-existant workspace!"
    echo "$RESULT" | jq -C .data
    exit 1
  else
    echo "$RESULT" | jq -C .data
    echo "Workspace updated!"
  fi
else
  exit 5
fi
