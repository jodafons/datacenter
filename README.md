#

## 🚀 HPC Infrastructure Documentation
This repository contains documentation and installation scripts for our HPC infrastructure. The documentation is organized into logical groups to help you find what you need quickly.

### ⚙️ Essential Services
This section contains documentation for core services required for the infrastructure's operation.

SLURM Server: 📝 Instructions for installing and configuring the SLURM workload manager.

Auth Server: 🛡️ Guide to setting up the authentication server, including Kerberos and LDAP services.

Login Server: 🖥️ Scripts and documentation for the central login server.

DNS Server: 🌐 Details on configuring the DNS server for name resolution within the network.

VPN Server: 🔐 Information on setting up the VPN server for secure remote access.

### 🌐 External Services
These are services that are accessible from outside the core network or provide external functionality.

* Postgres Server: 🐘 Guide for installing and managing the PostgreSQL database server.
* Runner Server: 🏃‍♂️ Scripts for the runner server, used for continuous integration or job execution.
* Docker Server: 🐳 Instructions for setting up and managing the Docker host.
* WWW Server: 🌐 Documentation for the web server and its configuration.

### 🖥️ Compute Nodes
This section covers the setup and configuration of our compute nodes.

* Slurm Worker: 🔧 Installation and configuration guide for SLURM worker nodes.
* Bancada Node: 🛠️ Documentation for the bancada-node compute machine.

### 📦 Docker Composes
Useful Composes: 📄 A collection of useful Docker Compose files for various applications, designed to be used on the Docker server.

## Documents

Welcome to the documentation for our lab network! This repository contains guides for setting up and managing key services.

* 💻 Proxmox Installation - A guide to installing and configuring a Proxmox server, including steps for GPU passthrough and cluster management.

* 🐧 Debian Installation - Instructions for setting up a new Debian system.

* 🔑 Account Creation - A step-by-step process for creating new user accounts with LDAP and Kerberos.