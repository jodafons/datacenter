
# get name with ifconfig 
#device=$1
usermod -aG sudo cluster
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install net-tools

apt install -y vim resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
sudo service resolvconf restart


network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')


echo "
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto $network_interface
iface $network_interface inet static
  address 146.164.147.3
  netmask 255.255.255.0
  gateway 146.164.147.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces


systemctl restart networking
ifconfig

#
# Add some panic contraints in case of fail
#
echo "vm.panic_on_oom=1   ;enables panic on OOM">>/etc/sysctl.conf
echo "kernel.panic=10     ;tells the kernel to reboot ten seconds after panicking">>/etc/sysctl.conf


reboot now
