
# Authentication Server Documentation

This document provides a comprehensive guide for setting up an authentication server that includes **LDAP** for user and group management and **Kerberos** for secure authentication. The instructions are based on the provided installation scripts and a step-by-step manual process, adapted for a Debian server environment.

---

## 1 Quick Installation (Using Scripts)

For a fast, automated setup, you can use the provided scripts.

### 1.1 Network Configuration
First, run the network setup script. This will likely configure network interfaces and require a reboot.

```bash
source 01_setup_network.sh
```

### 1.2 Service Installation

After the server reboots, execute the remaining installation scripts to set up the core services.

```bash
source 02_install_base.sh
source 03_install_ldap.sh
source 04_install_kerberos.sh
```

-----

## 2 Step-by-Step Installation

For a more controlled and granular installation, follow these manual steps.

### 2.1 LDAP Configuration

This section details the setup of the OpenLDAP server. The domain will be `lps.ufrj.br`, and the base will be `dc=lps,dc=ufrj,dc=br`.

#### 2.1.1 Install LDAP Packages

Install the core LDAP server and utility packages.

```bash
apt install -y slapd ldap-utils
```

#### 2.1.2 Reconfigure `slapd`

Run this command to manually configure the LDAP server. Be prepared to answer a series of questions.

```bash
dpkg-reconfigure slapd
```

**Configuration Questions & Answers:**

  * **Omit OpenLDAP server configuration?** No
  * **DNS domain name:** `lps.ufrj.br`
  * **Organization name:** `lps.ufrj.br`
  * **Administrator password:** *Enter and confirm a strong password.*
  * **Do you want the database to be removed when slapd is purged?** No
  * **Move old database?** Yes

#### 2.1.3 Verify the Installation

To confirm that your server is running and to view its details, use the `slapcat` command.

```bash
slapcat
```

### 2.2 LAM (LDAP Account Manager) Installation

LAM is a web-based tool that simplifies the management of LDAP accounts.

#### 2.2.1 Install LAM

Install the LAM package from the Debian repositories.

```bash
apt install -y ldap-account-manager
```

#### 2.2.2 Configure via Web Interface

Access the web interface to finalize the setup.

1.  Open your browser and navigate to `http://auth.cluster/lam`.
2.  Click `[LAM configuration]` in the top-right corner, then click `Edit server profiles`.
3.  The default password is `lam`. Change it immediately in the `Profile password` section.
4.  In `Server settings`, set `Server address` and `Tree suffix` to match your server details.
5.  In `Security settings`, set `List of valid users` to `cn=admin,dc=cluster` (or the appropriate admin user for your setup).
6.  In the `Account types` tab, modify the settings to match your domain (e.g., `dc=lps,dc=ufrj,dc=br`).
7.  Save your changes and log in with your new admin password. If prompted, you can safely allow LAM to create any missing configurations.

### 2.3 Kerberos Configuration

This section outlines the process of configuring the Kerberos authentication service. The default realm will be `LPS.UFRJ.BR`.

#### 2.3.1 Adjust `debconf` Priority

Set the `debconf` priority to low to have more control over the installation process.

```bash
dpkg-reconfigure debconf
```

**Configuration Questions & Answers:**

  * **Interface:** Dialog
  * **Priority:** low

#### 2.3.2 Install Kerberos Packages

Install the Kerberos admin and KDC (Key Distribution Center) server packages. Pay close attention to the questions during the installation.

```bash
apt install krb5-{admin-server,kdc}
```

**Configuration Questions & Answers:**

  * **Default Kerberos version 5 realm:** `LPS.UFRJ.BR`
  * **Add locations of default Kerberos servers to /etc/krb5.conf?** Yes
  * **Kerberos servers for your realm:** `auth-server.lps.ufrj.br`
  * **Administrative server for your Kerberos realm:** `auth-server.lps.ufrj.br`
  * **Create the Kerberos KDC configuration automatically?** Yes
  * **Run the Kerberos V5 administration daemon (kadmind)?** Yes

#### 2.3.3 Create a New Realm

Create the Kerberos realm and set a strong master password.

```bash
krb5_newrealm
```

#### 2.3.4 Configure `/etc/krb5.conf`

Edit the Kerberos configuration file. Under the `[domain_realm]` section, add your domain definitions.

```ini
[domain_realm]
    .lps.ufrj.br = LPS.UFRJ.BR
    lps.ufrj.br = LPS.UFRJ.BR
```

**Optional:** Add a logging section to the end of the file.

```ini
[logging]
    kdc = FILE:/var/log/kerberos/krb5kdc.log
    admin_server = FILE:/var/log/kerberos/kadmin.log
    default = FILE:/var/log/kerberos/krb5lib.log
```

#### 2.3.5 Set Up Log Directories

If you added the optional logging section, create the necessary directories and set the correct permissions.

```bash
mkdir /var/log/kerberos
touch /var/log/kerberos/{krb5kdc,kadmin,krb5lib}.log
chmod -R 750 /var/log/kerberos
```

#### 2.3.6 Configure Access Control

Edit the `kadm5.acl` file to ensure the administrator access control line is present and uncommented.

```bash
# Edit /etc/krb5kdc/kadm5.acl
*/admin *
```

#### 2.3.7 Restart Services

Apply the changes by restarting the Kerberos daemons.

```bash
invoke-rc.d krb5-kdc restart
invoke-rc.d krb5-admin-server restart
```

#### 2.3.8 Add Policies and Principals (Optional)

Use the `kadmin.local` command-line tool to add password policies and new principals (users or services).

```bash
kadmin.local

add_policy -minlength 8 -minclasses 3 admin
add_policy -minlength 8 -minclasses 4 host
add_policy -minlength 8 -minclasses 4 service
add_policy -minlength 8 -minclasses 2 user
addprinc -policy admin root/admin
addprinc -policy user unprivileged_user
ank -policy admin root/admin
ank -policy admin cluster/admin

quit
```
