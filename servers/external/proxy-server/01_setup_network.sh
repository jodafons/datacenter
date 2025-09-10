address=146.164.147.40
network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')



#
# add as sudo
#
usermod -aG sudo cluster
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install net-tools


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
apt install -y vim resolvconf
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
service resolvconf restart



# others
apt install -y htop sshpass

reboot now

