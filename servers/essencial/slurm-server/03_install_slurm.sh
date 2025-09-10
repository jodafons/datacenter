

apt-get update
apt install -y linux-headers-$(uname -r)
apt install -y libdbus-1-dev default-libmysqlclient-dev build-essential libpam-dev ruby-rubygems
apt install -y gcc make libssl-dev libpam0g-dev ruby ruby-dev libmariadb-dev-compat libmariadb-dev mariadb-server bzip2 libmunge-dev libmunge2 munge
apt install -y libhttp-parser-dev libjson-c-dev ufw
gem install fpm

systemctl enable munge
systemctl start munge
systemctl stop mariadb
systemctl disable mariadb
systemctl enable mysql
systemctl start mysql


mysql -u root -e "create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('slurmdbpass');grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';
flush privileges;"

cp /etc/munge/munge.key /mnt/market_place/slurm_build

# install slurm
dpkg -i --force-overwrite /mnt/market_place/slurm_build/slurm-24.11.1_1.0_amd64.deb

useradd slurm
mkdir -p /etc/slurm 
mkdir -p /etc/slurm/prolog.d 
mkdir -p /etc/slurm/epilog.d 
chown -R slurm /etc/slurm
mkdir -p /var/spool/slurm/ctld 
mkdir -p /var/spool/slurm/d 
mkdir -p /var/log/slurm
chown -R slurm /var/spool/slurm/
cp files/slurm/slurm.conf /etc/slurm/
cp files/slurm/slurmdbd.conf /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf
chown -R slurm /etc/slurm
cp files/slurm/slurmdbd.service /etc/systemd/system/
cp files/slurm/slurmctld.service /etc/systemd/system/
cp files/slurm/slurm.conf /mnt/market_place/slurm_build

sudo ufw allow from any to any port 6817
sudo ufw allow from any to any port 6818
sudo ufw allow from any to any port 6819

systemctl daemon-reload
systemctl enable slurmdbd
systemctl start slurmdbd
systemctl enable slurmctld
systemctl start slurmctld

# check status
#systemctl status slurmdbd
#systemctl status slurmctld

# create accounts into SLURM db
sacctmgr add cluster caloba
sacctmgr add account compute-account description="Compute accounts" Organization=lps
sacctmgr create user joao.pinto account=compute-account adminlevel=None


# add sjstat
cp /mnt/market_place/slurm_build/slurm-24.11.1/contribs/sjstat /usr/bin

#reboot now


