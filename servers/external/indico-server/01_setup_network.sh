

address=146.164.147.42
network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')


apt-get update  --fix-missing

usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install -y net-tools rsync screen fpart htop


#
# apt install
#
apt-get update --fix-missing
apt install -y resolvconf





#
# Change IP
#

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
  address $address
  netmask 255.255.255.0
  gateway 146.164.147.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
"> /etc/network/interfaces

#netplan apply
systemctl restart networking


#
# resolv conf
#
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
service resolvconf restart


reboot now
