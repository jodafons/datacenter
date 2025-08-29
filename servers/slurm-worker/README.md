
# Install Caloba Base from scrach

After install the OS debian, follow the steps below to prepare the base node.


## Setup network (stage 1):

This script as `sudo` and it will setup the network configuration to `10.1.1.10`. Just tip:

```
source 01_setup_network.sh
```

## Install NFS, Kerberos and LDAP (stage 2):

To install NFS and kerberus tip:

```
source 02_install_base.sh
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
source 03_install_slurm.sh
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
source 04_install_singularity.sh
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



