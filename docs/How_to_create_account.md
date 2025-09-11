# How to Create a New User Account?

This guide explains the process for creating a new user account on the lab network. The process involves two main steps: creating the user in LDAP and then creating the Kerberos user.

**Important:** All usernames must follow the `first.lastname` format, using all lowercase letters (e.g., `joao.pinto`).

### 1\. Create the LDAP User

1.  Connect to the lab network. If you are not in the lab, you must use a VPN.
2.  Open the [LDAP Account Manager](http://auth-server.lps.ufrj.br/lam/) in your browser.
3.  Log in using your admin credentials.
4.  Click on **`new user`**.
5.  Fill in the **`first name`** and **`last name`** fields.
6.  Click on **`Unix`** (on the left side).
7.  Fill in the **`user name`** field using the `first.last` format with no capital letters (e.g., `joao.pinto`).
8.  Click **`save`** (in the top left corner).

### 2\. Create the Kerberos User

1.  Open an SSH connection to `auth-server` (146.164.147.3) with the command below:
    ```bash
    ssh cluster@auth-server.lps.ufrj.br
    ```
2.  Use the `kadmin` command to create the new user:
    ```bash
    sudo kadmin -q "ank -policy user username"
    ```
    Replace `username` with the user's account name you just created in the LDAP Manager (e.g., `joao.pinto`).
3.  You will be prompted to enter the admin password and then the user's password. The format for the username should be `@username`.

**Note:** All new users must change their passwords after their first login by using the `kpasswd` command.

-----

### Additional Commands

  * **List all users:**
    ```bash
    sudo kadmin -q "list_principals"
    ```
  * **Reset a user's password:**
    ```bash
    sudo kadmin -q "cpw username"
    ```






