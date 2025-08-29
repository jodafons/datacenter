

# to avoit recap...
[ -d "/usr/share/Modules/init" ] && source /usr/share/Modules/init/bash
if command -v module &> /dev/null
then
    echo "module command exist, skip the installation"
    exit 0
fi


basepath=$PWD

# Install dependencies
apt install -y tcl8.6-dev

# Install modules
#wget https://github.com/cea-hpc/modules/releases/download/v5.1.1/modules-5.1.1.tar.gz
#tar xfz modules-5.1.1.tar.gz
cd /tmp
curl -LJO https://github.com/cea-hpc/modules/releases/download/v5.3.1/modules-5.3.1.tar.gz
tar xfz modules-5.3.1.tar.gz
cd modules-5.3.1
./configure --prefix=/usr/share/Modules --modulefilesdir=/etc/modulefiles
make && make install

ln -s /usr/share/Modules/init/profilif.sh /etc/profile.d/modules.sh
#ln -s /usr/share/Modules/init/profile.csh /etc/profile.d/modules.csh
source /usr/share/Modules/init/bash

# setup modules
#mkdir /etc/modulefiles/cuda
#cp modules/cuda/11.4 /etc/modulefiles/cuda
cd $basepath
