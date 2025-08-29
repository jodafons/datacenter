

# install kerberos
sudo dpkg-reconfigure debconf # Dialog and Low priority as input in textbox
sudo apt install -y krb5-{admin-server,kdc}
sudo krb5_newrealm
sudo cp files/kadm5.acl /etc/krb5kdc/kadm5.acl
sudo cp files/krb5.conf /etc/krb5.conf
mkdir /var/log/kerberos
touch /var/log/kerberos/{krb5kdc,kadmin,krb5lib}.log
chmod -R 750  /var/log/kerberos
invoke-rc.d krb5-kdc restart
invoke-rc.d krb5-admin-server restart

# setup kerberos accounts and polices
kadmin.local -q "add_policy -minlength 8 -minclasses 3 admin"
kadmin.local -q "add_policy -minlength 8 -minclasses 4 host"
kadmin.local -q "add_policy -minlength 8 -minclasses 4 service"
kadmin.local -q "add_policy -minlength 8 -minclasses 2 user"
kadmin.local -q "addprinc -policy admin root/admin"
kadmin.local -q "addprinc -policy user unprivileged_user"
kadmin.local -q "ank -policy admin root/admin"
kadmin.local -q "ank -policy user joao.pinto"
kadmin.local -q "list_principals"