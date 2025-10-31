
apt-get update
apt install -y linux-headers-$(uname -r)
apt install -y libdbus-1-dev default-libmysqlclient-dev build-essential libpam-dev ruby-rubygems
apt install -y gcc make libssl-dev libpam0g-dev ruby ruby-dev libmariadb-dev-compat libmariadb-dev mariadb-server bzip2 libmunge-dev libmunge2 munge
apt install -y libhttp-parser-dev libjson-c-dev
gem install fpm

#
# install munge
#
apt install -y libmunge-dev libmunge2 munge
cp /mnt/market_place/slurm_build/munge.key /etc/munge/
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key
systemctl enable munge
systemctl restart munge

#
# install SLURM
#
dpkg -i /mnt/market_place/slurm_build/slurm-24.11.1_1.0_amd64.deb
mkdir /etc/slurm
ln -sf /mnt/market_place/slurm_build/slurm.conf /etc/slurm/slurm.conf
cp files/slurm/cgroup_allowed_devices_file.conf /etc/slurm
cp files/slurm/cgroup.conf /etc/slurm
cp files/slurm/gres.conf /etc/slurm/
cp files/slurm/slurmd.service /etc/systemd/system/
useradd slurm
mkdir -p /var/spool/slurm/d
mkdir -p /var/log/slurm


# configure grub
cp files/common/grub /etc/default
update-grub

# configure PAM/ssh
cp /mnt/market_place/slurm_build/slurm-24.11.1/contribs/pam/.libs/pam_slurm.so /lib/x86_64-linux-gnu/security/
cp files/common/sshd /etc/pam.d

systemctl enable slurmd
systemctl start slurmd

# add sjstat
cp /mnt/market_place/slurm_build/slurm-24.11.1/contribs/sjstat /usr/bin

reboot now

