#!/bin/bash

# Pull 389ds container
podman pull 389ds/dirsrv

# Start 389ds server container
podman run --name dirsrv --rm -dt --network=host --env='DS_DM_PASSWORD=drowssap' --env='LDAPBASE=dc=test,dc=poc' 389ds/dirsrv:latest

# Build container to run ssh server
podman build --tag sshsrv .

# Start sshd in container
podman run --name sshsrv --rm -dt --env='SSH_USERNAME=demo1' --network host sshsrv

# Configure 389ds server
podman exec -it dirsrv dsconf localhost backend create --suffix 'dc=test,dc=poc' --be-name test_poc --create-suffix --create-entries

echo "-------------------------"
echo "You need to add ssh pubkey to ldap using ldap-add-pubkey.sh script"
