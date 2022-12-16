#!/bin/bash
PUBKEY_FILE=$1
LDAP_HOST=$2
: ${LDAP_HOST:=host.containers.internal}

if [[ -f ${PUBKEY_FILE} ]]; then
    PUBKEY="$(cat $1)"
else
    echo "Please provide SSH pubkey to add to LDAP"
    exit 1
fi

(echo "dn: uid=demo_user,ou=people,dc=test,dc=poc"
echo "changetype: modify"
echo "add: nsSshPublicKey"
echo "nsSshPublicKey: ${PUBKEY}" ) | \
ldapmodify -x -H ldap://${LDAP_HOST}:3389/ -D 'cn=Directory Manager' -w drowssap
