
node_number=$1

echo "
# and how to activate them. For more information, see interfaces(5).
source /etc/network/interfaces.d/*
# The loopback network interface
auto lo
iface lo inet loopback

auto enp6s18
iface enp6s18 inet static
  address 10.1.1.$node_number
  gateway 10.1.1.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces

#netplan apply
systemctl restart networking
ifconfig