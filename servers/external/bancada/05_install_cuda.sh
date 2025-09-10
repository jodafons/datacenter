

#
# Disabe novauo
#

#echo "blacklist nouveau
#options nouveau modeset=0
#" > /etc/modprobe.d/blacklist-nouveau.conf
#apt install -y gnupg2
#sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/3bf863cc.pub
#sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
#sudo apt update --fix-missing
#apt install -y nvidia-modprobe
#sudo apt-get -y install software-properties-common
#sudo apt update -y && sudo apt upgrade -y



apt install -y linux-headers-$(uname -r)
#bash /mnt/market_place/nvidia/deps/NVIDIA-Linux-x86_64-550.144.03.run


echo ""
echo "Install CUDA..."
echo ""

#wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-repo-debian11-12-1-local_12.1.0-530.30.02-1_amd64.deb
#sudo dpkg -i cuda-repo-debian11-12-1-local_12.1.0-530.30.02-1_amd64.deb
#sudo cp /var/cuda-repo-debian11-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
#sudo add-apt-repository contrib
#sudo apt-get update
#sudo apt-get -y install cuda
#rm cuda-repo-debian11-12-1-local_12.1.0-530.30.02-1_amd64.deb
sudo apt-get -y install cuda-toolkit-12-1


#ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/ /usr/local/
#ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/cuda/include/cudnn* /usr/local/cuda/include
#ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/cuda/lib/libcudnn* /usr/local/cuda/lib64
#sudo chmod a+r /usr/local/cuda/include/cudnn* /usr/local/cuda/lib64/libcudnn*

echo ""
echo "checking all versions..."
echo ""
nvidia-smi
#nvcc --version

#cp files/nvidia /etc/init.d
#chmod 775 /etc/init.d/nvidia
#update-rc.d nvidia defaults

