#!/bin/sh
#
# vault-auth-ldap.sh
#

echo "Run the following command to authenticate with Vault using LDAP credentials and capture the auth token (enter your password manually when prompted):"
# shellcheck disable=SC2016
echo 'export VAULT_TOKEN=$(vault login -method ldap username=$USER | jq -r .auth.token)'
