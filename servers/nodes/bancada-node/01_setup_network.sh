
#
# Only for UBUNTU OS
#
ip_address=$1

usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install -y net-tools


sudo apt install -y resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > head
sudo mv head /etc/resolvconf/resolv.conf.d/
sudo service resolvconf restart

network_interface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

echo "network:
  version: 2
  ethernets:
     $network_interface:
        dhcp4: false
        addresses: [$ip_address/24]
        gateway4: 146.164.147.1
        nameservers:
          addresses: [8.8.8.8, 8.8.4.4, 146.164.147.2]" > 00-installer-config.yaml

sudo mv 00-installer-config.yaml /etc/netplan 
sudo netplan apply
ifconfig



#
# resolv conf
#
apt install -y resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
service resolvconf restart


apt install -y nfs-common
#mkdir -p /mnt/market_place
#echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab


#reboot now
