

address=146.164.147.7
network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')



usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install -y net-tools rsync screen fpart htop


#
# apt install
#
apt-get update --fix-missing
apt install -y resolvconf
apt install -y nfs-common



#
# add all NFS workplaces
#
mkdir -p /mnt/storage01
mkdir -p /mnt/storage02
mkdir -p /mnt/storage03
echo "10.1.1.202:/volume1 /mnt/storage01 nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.203:/volume1 /mnt/storage02 nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.204:/shares /mnt/storage03 nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
mount -a




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
