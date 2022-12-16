FROM fedora/ssh:latest

COPY ldap-pubkeys.sh /etc/ssh/ldap-pubkeys.sh
COPY ldap-add-pubkey.sh /ldap-add-pubkey.sh
COPY ldap-del-pubkey.sh /ldap-del-pubkey.sh

RUN chmod 700 /etc/ssh/ldap-pubkeys.sh && chown root /etc/ssh/ldap-pubkeys.sh

RUN dnf install -y openldap-clients

RUN sed -i \
  -e 's/^#Port 22/Port 2200/' \
  -e 's/#LogLevel INFO/LogLevel DEBUG2/' \
  -e 's/\(AuthorizedKeysFile\).*/\1 \tnone/' \
  -e 's/^#\(AuthorizedKeysCommand\) .*/\1 \/etc\/ssh\/ldap-pubkeys.sh/' \
  -e 's/^#\(AuthorizedKeysCommandUser\) .*/\1 root/' \
  /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D", "-e"]
