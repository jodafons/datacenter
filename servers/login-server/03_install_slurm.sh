
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
dpkg -i --force-overwrite /mnt/market_place/slurm_build/slurm-24.11.1_1.0_amd64.deb
mkdir /etc/slurm
ln -sf /mnt/market_place/slurm_build/slurm.conf /etc/slurm/slurm.conf
useradd slurm


# add sjstat
cp /mnt/market_place/slurm_build/slurm-24.11.1/contribs/sjstat /usr/bin

reboot now

