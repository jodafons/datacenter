
hostname=$1
ip_address=$2

# reconfigure ssh-keys
dpkg-reconfigure openssh-server


# add node into kerberos
#kadmin -w $password -q "addprinc -policy service -randkey host/$hostname.lps.ufrj.br"
#kadmin -w $password -q "ktadd -k /etc/krb5.keytab host/$hostname.lps.ufrj.br"


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
  address $ip_address
  gateway 10.1.1.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces


#netplan apply
systemctl restart networking


sudo reboot now