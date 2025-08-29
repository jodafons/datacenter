
# Install Caloba Base from scrach

After install the OS debian, follow the steps below to prepare the base node.

## Setup network (stage 1):

This script as `sudo` and it will setup the network configuration to `10.1.1.10`. Just tip:

```
source setup_network.sh
```

## Install NFS, Kerberos and LDAP (stage 2):

To install NFS and kerberus tip:

```
source install_base.sh
```

Some Q&A must be filled:

###  Kerberos configuration:

- Default Kerberos version 5 realmn: `LPS.UFRJ.BR`
- Kerberos servers for your realm: `auth-server.lps.ufrj.br`
- Administrative server for your kerberos realm: `auth-server.lps.ufrj.br`
- Tip your `admin` password


### LDAP configuration:

- LDAP server URI: `ldap://auth-server.lps.ufrj.br`
- Distinguished name of the search base: `dc=lps,dc=ufrj,dc=br`
- LDAP version to use: `3`
- LDAP account for root: `cn=admin,dc=lps,dc=ufrj,dc=br`
- LDAP root account password: `your admin password`
- tip `OK` once again
- Aloow LDAP admin account to behave like local root? `Yes`
- Does LDAP database require login? `No`
- LDAP administrative account: `cn=admin,dc=lps,dc=ufrj,dc=br`
- LDAP root account password: `your admin password`

Than, after some packages installation, you will be require to answer once again:

- Say `OK` for the first two questions (dont need to fill it).
- Than, mark `passwd`, `group` and `shadown` and tip `OK`

After complete all, the machine will be rebooted.

### Health check:

When machine back, before move to the next stage, check:

- Check LDAP with `getend passwd`. You should be able to see all cluster users;
- Check NFS places in `ls /mnt`. You shout be able to see at least `market_place`,

If everything is fine, now let´s move to the next stage

## Install SLURM (stage 3):


To install `slurm`, tip this command:

```
source install_slurm.sh
```

### Health check:

To check if eveything is working, just tip:

```
sinfo
```

if you got the slurm configuratio, just move to the next stage. Just ensure that slurm master node is worling.


## Install Singularity (stage 4):

Just tip as `sudo`:

```
source install_singularity.sh
```

### Health check:

Tip `singularity` into the terminal. If you get the `man` page, eveything its ready.



## Install NVIDIA (stage 5):


### Add pci device by proxmox:
To install this, just ensure that the nvidia card was added by proxmox interface in `pci devices`.
First fix the kernel to avoid problems when install the driver.

- Go to the virtual node using the proxmox interface.
- Tham click on hardware.
- Click on `Add` than `PCI Device`.
- Select the gpu card by name and mark `all functions`, than advanced and `PC-Express`. Finally, `Add`.
- Turn-on the virtual node

### Install driver:

```
sudo su
apt install -y linux-headers-$(uname -r)
```

Than install the nvidia driver using the last version from:

```
bash /mnt/market_place/nvidia/deps/NVIDIA-Linux-x86_64-535.154.05.run
```

If you are running this for the first time, probably you will need to reboot the node. Just following the terminal instructions. When back once again, just repeat the procedure.

Q&A options:
- Tip `OK` for first warning
- Install NVIDIA 32 bit compability libraries? `No`
- Tip `OK` for second warning
- Would you like to run the nvidia-xconfig utility to automatically... ? `Yes`
- Finally, `OK`


Tip `nvidia-smi` to check if the gpu is available.


### Install CUDA 


```
source install_cuda.sh
```

Q&A options:
- Accept the licence: `accept`
- On CUDA Installer menu, mack only `CUDA Toolkit`, than click on `Install`
- Overwrite cuda link: `Yes`

To check if cuda is ready, tip `nvcc --version`.




###

1 - Install
2 - English
3 - Other
4 - South America
5 - Brazil
6 - United States
7 - American English
8 - Hostname: slurm-worker
9 - Domain: lps.ufrj.br
10 - No passoword for root (just continue)
11 - No password for root (continue again)
12 - full name: cluster
13 - user name: cluster
14 - master password (click in the box to be sure about of the pasword)
15 - retype the passoword again
16 - configure clock: Sao paulo
17 Partition disk configuration:
17.1 select manual option
17.2 select the HARDDISK name option
17.3 Create new empty partition table on this device? Yes
17.4 Select the FREE SPACE option 
17.5 create a new partition
17.6  new partition size: just continue with the total size
17.7 Type for the new partition: primary
17.8 finally, select "don sessint up the partition"
17.9 finish partitioning and write changes to disk
17.10 do you want to retrn to the partitoning menu? No
17.11 Write the changes to disk? yes

18 Configure the package manager
18.1 Scan extra installation media? No
18.2 Debian archive mirror country: brazil
18.3: select: deb.debian.org
18.4: HTTP proxy: blank

19 Participate in the package usage survey? No
20 Choose software to install: selec only SSH server and standard system utilities (last two options)

21 Install the GRUP boot loader to your primary drive? Yes
22 select the device boot loader intallation: usually /dev/sda (second option)

23 click in contine to complete the installation, the macine will reboot






