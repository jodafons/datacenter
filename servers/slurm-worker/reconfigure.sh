
password=$1
hostname=$2
node=$3
echo "start reconfigure..."
# reconfigure ssh-keys
dpkg-reconfigure openssh-server


# add node into kerberos
kadmin -w $password -q "addprinc -policy service -randkey host/$hostname.lps.ufrj.br"
kadmin -w $password -q "ktadd -k /etc/krb5.keytab host/$hostname.lps.ufrj.br"

echo "change hostname..."
# change hostname
hostnamectl set-hostname $hostname
echo "127.0.0.1       localhost
127.0.1.1       $hostname.lps.ufrj.br    $hostname
# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts
hostnamectl


# change ip
network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

echo "
# and how to activate them. For more information, see interfaces(5).
source /etc/network/interfaces.d/*
# The loopback network interface
auto lo
iface lo inet loopback

auto $network_interface
iface $network_interface inet static
  address 10.1.1.$node
  gateway 10.1.1.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces

echo "restarting network...."
#netplan apply
systemctl restart networking

echo "reboot now!"
sudo reboot now
