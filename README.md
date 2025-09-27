## Datacenter

This repository contains all scripts and topology of the Caloba cluster. The Caloba cluster is a High-Performance Computing (HPC) environment based on SLURM, designed to efficiently manage and schedule jobs across multiple nodes, providing users with the resources they need for computational tasks.

* [infrastructure installation](servers/README.md)
* 💻 [Proxmox Installation](docs/How_to_install_Proxmox.md): A guide to installing and configuring a Proxmox server, including steps for GPU passthrough and cluster management.
* 🐧 [Debian Installation](docs/How_to_Install_Debian.md): Instructions for setting up a new Debian system.
* 🔑 [Account Creation](docs/How_to_create_account.md): A step-by-step process for creating new user accounts with LDAP and Kerberos.
* 💾 [Bootable Pendrive](docs/How_to_create_bootable_pendrive.md): Instructions for create a bootable pendrive on Linux or MacOS.


### Recreate the cluster

play cluster create -n cpu-large

### Reboot all physical nodels

play cluster reboot -n cpu-large

### Restore a node into the cluster:

play vm create -n caloba51

### Destroy a node into the cluster:

play vm destroy -n caloba51

