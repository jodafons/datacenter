# Cluster System Directory

This directory contains the core components for a computing cluster. Each folder represents a different service or node type, with a dedicated `README.md` file inside providing detailed setup and configuration instructions for that specific component.

---

### `auth_server/`
This folder contains the configuration for the authentication server. It is responsible for managing user accounts and credentials using services like LDAP and Kerberos, ensuring secure access to all cluster resources.

* [View Authentication Server README](auth_server/README.md)

---

### `dns_server/`
This directory holds the configuration and scripts for the DNS server. It is responsible for hostname resolution within the cluster, ensuring that all nodes can communicate with each other by name rather than IP address.

* [View DNS Server README](dns_server/README.md)

---

### `vpn_server/`
The files in this folder are used to set up the VPN server. This service provides a secure and encrypted tunnel, allowing administrators and users to access the cluster's private network from external locations.

* [View VPN Server README](vpn_server/README.md)

---

### `slurm_server/`
This directory contains the configuration for the Slurm controller. The Slurm Workload Manager is a job scheduler that allocates compute nodes to users for their jobs and manages the queue of tasks to be executed on the cluster.

* [View Slurm Server README](slurm_server/README.md)

---

### `slurm_worker/`
This folder contains the setup for the Slurm worker nodes. These are the compute nodes where user jobs are actually executed. They communicate with the Slurm controller to receive tasks and report their status.

* [View Slurm Worker README](slurm_worker/README.md)

---

### `login_server/`
The files in this directory are for the login server, which acts as the main access point for users. It is the machine that users connect to via SSH to submit jobs to the Slurm scheduler and manage their files.

* [View Login Server README](login_server/README.md)

### `login_server/`
The files in this directory are for the login server, which acts as the main access point for users. It is the machine that users connect to via SSH to submit jobs to the Slurm scheduler and manage their files.

* [View Login Server README](login_server/README.md)