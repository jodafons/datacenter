


# to avoit recap...
#if command -v singularity &> /dev/null
#then
#    echo "singularity command exist, skip the installation"
#    exit 0
#fi


#
# Configuration
#
basepath=$PWD
export GOVERSION=1.17.3 OS=linux ARCH=amd64  # change this as you need
export SINGVERSION=v3.8.4

# Ensure repositories are up-to-date
apt-get -y update
# Install debian packages for dependencies
apt install -y \
    build-essential \
    libseccomp-dev \
    pkg-config \
    squashfs-tools \
    cryptsetup
    

#
# Install go
#
wget -O /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz \
  https://dl.google.com/go/go${GOVERSION}.${OS}-${ARCH}.tar.gz
sudo tar -C /usr/local -xzf /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
#source ~/.bashrc
export PATH=$PATH:/usr/local/go/bin

#
# Install Singularity
#
cd /tmp/
git clone https://github.com/hpcng/singularity.git
cd singularity
git checkout $SINGVERSION
./mconfig
make -C ./builddir
make -C ./builddir install
singularity --version

cd $basepath

python /mnt/market_place/scripts/datacenter/data/scripts/configure_singularity.py
