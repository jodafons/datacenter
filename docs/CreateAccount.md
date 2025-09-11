
# How to Create a New Account

**All users must be like first.lastname to avoid problems**


## LDAP User Creation:

First, you need to be into the lab network (VPN in case of external usage).
Than you need to connect with the [LDAP Account Manager](http://auth-server.lps.ufrj.br/lam/). 
And use your admin credentials to login into the service. Than, click 
`new user` and fill the `first name` and `last name` fields.

Than click in `Unix` (left side), and fill the `user name` follow this format `first.last` name (e.g. `joao.pinto`) with `no capital letters`.
Finally, click in `save` (top left).

## Kerberos User Creation:


Open a `ssh` connection with `auth-server` (146.164.147.3):

```
ssh cluster@auth-server.lps.ufrj.br
```

Than create the new user with this command:

```
sudo kadmin -q "ank -policy user username"
```

Where `username` will be the account created at LDAP manager (e.g. `joao.pinto`). You will need to type the `admin` password and type the 
user password. The format adopted should be `@username`.

**NOTE** All new clients must change his passwords after first login using
the `kpasswd` command.


## List users:

```
sudo kadmin -q "list_principals"
```

## Reset User Password:

```
sudo kadmin -q "cpw username"
```








