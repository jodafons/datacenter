

address=146.164.147.44
network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')


usermod -aG sudo cluster
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster

#
# apt install
#
apt install net-tools
apt install -y htop sshpass net-tools rsync screen fpart
apt install -y nfs-common
apt install -y vim resolvconf


#
# NFS
#
mkdir -p /mnt/postgres_data
mkdir -p /mnt/market_place
echo "10.1.1.203:/volume1/postgres_data /mnt/postgres_data nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab



#
# IP static
#
echo "
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto $network_interface
iface $network_interface inet static
  address $address
  netmask 255.255.255.0
  gateway 146.164.147.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces
systemctl restart networking
ifconfig


#
# resolv
#
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
service resolvconf restart


reboot now

