#
# Append market_place into the mount
#

apt install -y nfs-common
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
#echo "10.1.1.202:/volume1/homes /mnt/home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab

