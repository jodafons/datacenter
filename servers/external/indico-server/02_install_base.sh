#
# Install dependencies
#
apt install -y htop vim git sshpass curl wget build-essential python3-virtualenv python-is-python3 screen rsync

apt install -y nfs-common


#
# NFS
#
mkdir -p /mnt/market_place
mkdir -p /mnt/shared/storage03/volumes
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.204:/shares/volumes /mnt/shared/storage03/volumes nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab



#
# Install docker
#
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
groupadd docker
gpasswd -a root docker
gpasswd -a cluster docker


reboot now
