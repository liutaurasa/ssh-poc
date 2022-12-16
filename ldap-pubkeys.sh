#!/bin/bash

USER_NAME=$1
# HOST_NAME=$(hostname)

logger -p "AUTH.info" "Checking for user $1"

PUB_KEYS=$(ldapsearch -x -H ldap://host.containers.internal:3389/ -o ldif-wrap=no -D 'cn=Directory Manager' -w drowssap -b 'dc=test,dc=poc' 'uid=demo_user' -LLL nsSshPublicKey | grep nsSshPublicKey: | sed 's/nsSshPublicKey: //g')

logger -p "AUTH.info" "Found pubkeys ${PUB_KEYS}"

echo "${PUB_KEYS}"
