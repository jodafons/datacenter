
# Station

Install the latest Operation System such as Ubuntu 22.04. You can download [here](https://drive.google.com/file/d/1veSJFoA0WfP-LOW_2One5Z7XbOOBC26v/view?usp=share_link). Follow the instructions to build a bootable pendrive [here](../../../docs/How_to_create_bootable_pendrive.md)

Lets start with `bancada01` as example.

* Hostname: `bancada01`
* Username: `cluster`

## Network Configuration

First, run the network configuration script:


```
source 01_setup_network.sh [id_of_the_node]
```

## Kerberos, NFS and LDAP:

```
source 02_install_base.sh
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
source 03_install_singularity.sh (Extremelly recomended)
source 04_install_docker.sh (not recomended)
```



