sudo rm -rf /etc/ldap/slapd.d/* /var/lib/ldap/*
sudo systemctl stop slapd.service
sudo slapadd -F /etc/ldap/slapd.d -b cn=config -l /mnt/market_place/data/config.ldif
sudo slapadd -F /etc/ldap/slapd.d -b dc=lps,dc=ufrj,dc=br -l /mnt/market_place/data/lps.ufrj.br.ldif
sudo chown -R openldap:openldap /etc/ldap/slapd.d/
sudo chown -R openldap:openldap /var/lib/ldap/
sudo systemctl start slapd.service
