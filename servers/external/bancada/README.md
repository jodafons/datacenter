
# Station

Install the latest Operation System such as Ubuntu 22.04.
Lets start with `geneve` as example.

* Hostname: `geneve`
* Username: `cluster`

## Network Configuration

First, tip `fconfig` and get the name of the network interface. Example:


```
source setup_network.sh ens8p 201
```

Where `ens8p` is the name of the network device and `201` is the IP last number (See DNS table).

## Kerberos, NFS and LDAP:

```
source install_base.sh
```


### Q&A:

- Kerberos realm: `LPS.UFRJ.BR`
- Kerberos server: `auth-server.lps.ufrj.br`
- Kerberos adm-server: `auth-server.lps.ufrj.br`
- LDAP server: `ldap://auth-server.lps.ufrj.br` or `ldap://146.164.147.3`
- Distinguished name of the search base: `dc=lps,dc=ufrj,dc=br`
- LDAP version: 3
- Select yes to create the local root database;
- Answer No for Does the LDAP database requires login?
- Set LDAP account for root, like `cn=admin,dc=lps,dc=ufrj,dc=br`
- Provide LDAP root account Password


Again, fill things to match your own. In order to ease configuration, I'll install another package where we can choose which services we'll enable. In my case, I just checked `passwd`, `group` and `shadow`

To test LDAP, use this command and you shoul see some accounts inside of the LDAP server:

```
getent passwd
```

## Install Docker and Singularity (Optional):

```
source install_docker.sh (not recomended)
source install_singularity.sh (Extremelly recomended)
```



