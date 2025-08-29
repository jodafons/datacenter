basepath=$pwd
apt-get update
apt install -y linux-headers-$(uname -r)
apt install -y libdbus-1-dev default-libmysqlclient-dev build-essential libpam-dev ruby-rubygems
apt install -y gcc make libssl-dev libpam0g-dev ruby ruby-dev libmariadb-dev-compat libmariadb-dev mariadb-server bzip2 libmunge-dev libmunge2 munge
apt install -y libhttp-parser-dev libjson-c-dev
gem install fpm



mkdir -p /mnt/market_place/slurm_build
cd /mnt/market_place/slurm_build
wget https://download.schedmd.com/slurm/slurm-24.11.1.tar.bz2
bunzip2 slurm-24.11.1.tar.bz2
tar xfv slurm-24.11.1.tar && rm slurm-24.11.1.tar
cd slurm-24.11.1
./configure --prefix=/mnt/market_place/slurm_build/build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
make -j8
make install
make contrib
cd ..

sudo fpm -s dir -t deb -v 1.0 -n slurm-24.11.1 --prefix=/usr -C /mnt/market_place/slurm_build/build .
cd $basepath