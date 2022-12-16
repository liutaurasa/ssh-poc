# ssh-poc
PoC of ssh with no local autheorizedkeys

This is an attempt to demonstrate how openssh server's AuthorizedKeysCommand can be used to get ssh pubkeys from LDAP server.
The idea is to start 2 containers:
- LDAP server
- SSH server

Both containers should be modified slightly for this PoC.

389ds is used as an LDAP server. After starting the 389ds/dirsrv container a backend database and suffix needs to be created and LDAP records should be created.

To test this PoC:
```
git clone https://github.com/liutaurasa/ssh-poc
```
run the script from this repository to do all the work:
```
./run-poc.sh
```
The script will pull fedora/ssh and 389ds/dirsrv containers, will use `podman build` modify ssh container using Dockerfile by installing openldap-clients package for ldapsearch and ldapmodify utilities and will change sshd server configuration to run on port 2200/tcp and use authorizedkeys only provided be AuthorizedKeysCommand.
When both containers are running you need to submit your ssh pubkey to LDAP. Use helper scripts `ldap-add-pubkey.sh` and `ldap-del-pubkey.sh`. These scripts are also included in **sshsrv** container so you can run them in **sshsrv** container in case you don't have ldapmodify utilities on the host.

To add pubkey to LDAP run the script on the host:
```
./ldap-add-pubkey.sh <pubkey file> localhost
```
or copy your pubkey to the sshsrv container and run the script in the container
```
podman cp <pubkey file> sshsrv:/
podman exec -it sshsrv /bin/bash /ldap-add-pubkey.sh /<pubkey file>
```
You are ready to test ssh now:
```
ssh localhost -p 2200 -l demo1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```
(`-o` is just for convenience to not use known_hosts files in case you restart containers)

