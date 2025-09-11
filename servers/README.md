#

## 🚀 HPC Infrastructure Documentation
This repository contains documentation and installation scripts for our HPC infrastructure. The documentation is organized into logical groups to help you find what you need quickly.

### ⚙️ Essential Services
This section contains documentation for core services required for the infrastructure's operation.

[SLURM Server](essencial/slurm-server/README.md): 📝 Instructions for installing and configuring the SLURM workload manager.

[Authenticator Server](essencial/auth-server/README.md): 🛡️ Guide to setting up the authentication server, including Kerberos and LDAP services.

[Login Server](essencial/login-server/README.md): 🖥️ Scripts and documentation for the central login server.

[DNS Server](essencial/login-server/README.md): 🌐 Details on configuring the DNS server for name resolution within the network.

[VPN Server](essencial/vpn-server/README.md): 🔐 Information on setting up the VPN server for secure remote access.

### 🌐 External Services
These are services that are accessible from outside the core network or provide external functionality.

* [Postgres Server](external/postgres-server/README.md): 🐘 Guide for installing and managing the PostgreSQL database server.
* [Runner Server](external/runner-server/README.md): 🏃‍♂️ Scripts for the runner server, used for continuous integration or job execution.
* [Docker Server](external/docker-server/README.md): 🐳 Instructions for setting up and managing the Docker host.
* [WWW Server](external/www-server/README.md): 🌐 Documentation for the web server and its configuration.

### 🖥️ Compute Nodes
This section covers the setup and configuration of our compute nodes.

* [Slurm Worker](nodes/slurm-node/README.md): 🔧 Installation and configuration guide for SLURM worker nodes.
* [Bancada Node](nodes/bancada-node/README.md): 🛠️ Documentation for the bancada-node compute machine.

### 📦 Docker Composes
Useful [Composes](composes/README.md): 📄 A collection of useful Docker Compose files for various applications, designed to be used on the Docker server.

