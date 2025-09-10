

# Login Server:

This server is responsible to be the gate to all clients in
the network and should be exposed to the internet. 


# Easy Installation:

```
source setup_network.sh
```

After reboot,

```
source install_base.sh
source install_slurm.sh
```



# Installation Step by Step:

## Kerberos Client Configuration:

Install few packages (the setup is pretty straightforward, just fill things to match your own)

```
apt install -y krb5-config krb5-user
```

### Q&A:

* Kerberos realm: `LPS.UFRJ.BR`
* Kerberos server: `auth-server.lps.ufrj.br`
& Kerberos adm-server: `auth-server.lps.ufrj.br`

[Optional] Test Kerberos setup by doing

```
kinit -p <your-username>
klist
kdestroy
```

For this optional step, you need to have at least one principal added on the server.

Next, we'll need to use PAM for Kerberos authentication. For that, install

```
apt install -y libpam-krb5
```

## LDAP Client Configuration:

The default configurations after installation should work fine. Next, we'll set LDAP with NSS

```
apt install -y libnss-ldap
```

## Q&A:

- server: `ldap://auth-server.lps.ufrj.br` or `ldap://146.164.147.3`
- Distinguished name of the search base: `dc=lps,dc=ufrj,dc=br`
- LDAP version: 3
- Select yes to create the local root database;
- Answer No for Does the LDAP database requires login?
- Set LDAP account for root, like `cn=admin,dc=lps,dc=ufrj,dc=br`
- Provide LDAP root account Password


Again, fill things to match your own. In order to ease configuration, I'll install another package where we can choose which services we'll enable. In my case, I just checked `passwd`, `group` and `shadow`

```
apt install -y libnss-ldapd
```

Once that's done, do

```
/etc/init.d/nscd restart
/etc/init.d/ssh restart
```

Next, we'll setup PAM for creating home directories for users that don't have it yet. For that, edit the `/etc/pam.d/common-session` file by adding this line to the end of it

```
session    required    pam_mkhomedir.so skel=/etc/skel/ umask=022
```

To test LDAP, use this command and you shoul see some accounts inside of the LDAP server:

```
getent passwd
```

Finally, we'll setup passwordless SSH using Kerberos tickets. For that, inside the `kadmin` shell, run (replacing `<hostname.hostdomain>`):

```
addprinc -policy service -randkey host/slurm-server.lps.ufrj.br
ktadd -k /etc/krb5.keytab host/slurm-server.lps.ufrj.br
```

Then edit the `/etc/ssh/sshd_config` file to match the following:

```
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
GSSAPIKeyExchange yes
UsePAM yes
```

Restart SSH service

```
invoke-rc.d ssh restart
```

And you're done! Remember that, for this to work, **you have to create users both on LAM and on Kerberos server**. The password set on LAM can be anything, since the authentication is made through Kerberos. The LDAP server here is mostly used to store home path information and UID/GID management.


## Setting up mounts

Start by installing `nfs-common` and making directories

```
apt install nfs-common
```

After that, edit your `/etc/fstab` file for auto mount, appeding something like this on the bottom (always match your setup)

```
10.1.1.202:/volume1/homes /home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0
10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0

```

You can now mount everything

```
mount -a
```


Now we'll set PAM to create users' storage dir (if needed) at login and a logger script

```
mkdir /etc/pam_scripts
chmod -R 700 /etc/pam_scripts
chown -R root:root /etc/pam_scripts
```

Create SSH Logger script (`/etc/pam_scripts/login-logger.sh`):

```
#!/bin/sh

LOG_FILE="/var/log/ssh-auth"

DATE_ISO=`date --iso-8601="seconds"`
LOG_ENTRY="[${DATE_ISO}] ${PAM_TYPE}: ${PAM_USER} from ${PAM_RHOST}"

if [ ! -f ${LOG_FILE} ]; then
	touch ${LOG_FILE}
	chown root:adm ${LOG_FILE}
	chmod 0640 ${LOG_FILE}
fi

echo ${LOG_ENTRY} >> ${LOG_FILE}

exit 0
```

Create storage creation script  (`/etc/pam_scripts/storage.sh`):

```
#!/bin/sh

if [ ! -d "/storage/${PAM_USER}" ]; then
	mkdir -p /storage/${PAM_USER}
	chown -R ${PAM_USER}:storage /storage/${PAM_USER}
	chmod -R 0700 /storage/${PAM_USER}
fi

exit 0
```

and:

```
chmod +x /etc/pam_scripts/login-logger.sh
```

Append this to `/etc/pam.d/sshd`:

```
# Post Login Scripts
session required pam_exec.so /etc/pam_scripts/login-logger.sh
```

And you're done!

## Syncing clocks with NTP:

Edit the following file: `/etc/systemd/timesyncd.conf` by making it look like this (match your own setup)

```
[Time]
NTP=1.br.pool.ntp.org 0.br.pool.ntp.org
```

Uncomment `FallbackNTP` line, but leave it as is.

Then enable NTP and check its status

```
timedatectl set-ntp true
timedatectl status
```

And you're done again! After this step, you're ready to install slurm and configure it.


**At this point, you shoud reboot to access the storage home folder** 


## SLURM Configuration:


First we're gonna install MUNGE, for authentication

```
apt update
apt install libmunge-dev libmunge2 munge
```

We need to have the same copy of `munge.key` (located at `/etc/munge/munge.key`) for every node. In order to do that, copy it from `host.cluster` to every other machine. One way to do that is over SCP

```
cp /mnt/market_place/slurm_build/munge.key /etc/munge/
```

Then fix permissions

```
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key
```

And restart MUNGE

```
systemctl enable munge
systemctl restart munge
```

After setting MUNGE, we're going to install the same copy of SLURM we've built on the host machine by doing

```
dpkg -i /mnt/market_place/slurm_build/slurm-22.05.3/slurm-22.05.3_1.0_amd64.deb 
```

Next, we need to create the `/etc/slurm` directory and have the same copy of `/etc/slurm/slurm.conf` on every machine. Similarly to the MUNGE key, do

```
mkdir /etc/slurm
cp /mnt/market_place/slurm_build/slurm.conf /etc/slurm/
```

Then you need to create the `/etc/slurm/gres.conf` file, which takes care of listing resources other than CPUs (like GPUs, for example). **In my case, this will be just an empty file** but, if you need an example, a configuration for the GPU server is below

```
NodeName=caloba22 Name=gpu File=/dev/nvidia[0-1] CPUs=0-15
```

After that, as we'll use `cgroup`, you need to create both of these files:

* `/etc/slurm/cgroup.conf`

```
CgroupAutomount=yes 
CgroupReleaseAgentDir="/etc/slurm/cgroup" 

ConstrainCores=yes 
ConstrainDevices=yes
ConstrainRAMSpace=yes
#TaskAffinity=yes
```

* `/etc/slurm/cgroup_allowed_devices_file.conf`

```
/dev/null
/dev/urandom
/dev/zero
/dev/sda*
/dev/cpu/*/*
/dev/pts/*
/dev/nvidia*
```

This will be useful later for forbiding users from SSH into machines they have no jobs allocated

Then, create missing SLURM user and make some directories

```
useradd slurm
mkdir -p /var/spool/slurm/d
```

At this point, if you've done everything right, you should be able to do `sinfo` and see your node state `idle`. But now, we'll configure `cgroup` in order to be able to manage memory quotas. For that, open `/etc/default/grub` for edition and match the following line

```
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
```

If your system uses cgroup v2 (as Debian bullseye):

```
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1 systemd.unified_cgroup_hierarchy=false systemd.legacy_systemd_cgroup_controller=false"
```

and add service:

```
cp slurmd.service /etc/systemd/system/
systemctl enable slurmd
systemctl start slurmd
```

After that, update GRUB and reboot the machine

```
update-grub
reboot now
```



To finish the configuration of the nodes, we'll forbid users from ssh-ing into a compute node on which they do not have a job allocation AND we'll add sjstat, which is a very nice command. In order to do that, do

```
cp /mnt/market_place/slurm_build/slurm-22.05.3/contribs/sjstat /usr/bin/.
cp /mnt/market_place/slurm_build/slurm-22.05.3/contribs/pam/.libs/pam_slurm.so /lib/x86_64-linux-gnu/security/
```

and then edit the file `/etc/pam.d/sshd` by adding the following lines just **before** the first `required` statement:

```
account    sufficient   pam_localuser.so
account    required     /lib/x86_64-linux-gnu/security/pam_slurm.so
```

This way, we forbid SLURM users from doing any bypass on deploying workload into nodes and still allow non-SLURM users to SSH normally. And we're done with the nodes!


