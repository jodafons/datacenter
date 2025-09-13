

#
# cluster as sudo with no password
#
apt-get update --fix-missing


usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install -y net-tools


#
# change hostname
#

hostnamectl set-hostname slurm-node
echo "127.0.0.1       localhost
127.0.1.1       slurm-node.lps.ufrj.br    slurm-node
# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts
hostnamectl




#
# Change IP
#
network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

echo "
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto $network_interface
iface $network_interface inet static
        address 10.1.1.210/24
        gateway 10.1.1.1
        dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
"> /etc/network/interfaces

#netplan apply
systemctl restart networking


#
# resolv conf
#
apt install -y resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
service resolvconf restart


#
# add all NFS workplaces
#
apt install -y nfs-common
mkdir -p /mnt/market_place
mkdir -p /mnt/cern_data
mkdir -p /mnt/brics_data
mkdir -p /mnt/sonar_data
mkdir -p /mnt/petrobras_data


echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.203:/volume1/cern_data /mnt/cern_data nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.203:/volume1/brics_data /mnt/brics_data nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.203:/volume1/sonar_data /mnt/sonar_data nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.203:/volume1/petrobras_data /mnt/petrobras_data nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab

mount -a

reboot now