
# recopy everything to SLURM
echo "recopy..."
sudo cp files/slurm/slurm.conf /etc/slurm/
sudo cp files/slurm/slurmdbd.conf /etc/slurm
sudo chmod 600 /etc/slurm/slurmdbd.conf
sudo chown -R slurm /etc/slurm
sudo cp files/slurm/slurmdbd.service /etc/systemd/system/
sudo cp files/slurm/slurmctld.service /etc/systemd/system/
sudo cp files/slurm/slurm.conf /mnt/market_place/slurm_build
sudo cp files/slurmweb/agent.ini  /etc/slurm-web/
sudo cp files/slurmweb/gateway.ini  /etc/slurm-web/
#sudo cp files/slurmweb/policy.ini  /etc/slurm-web/
sudo cp files/slurmweb/gateway.yml /usr/share/slurm-web/conf/ # bugfix
sudo cp files/slurmweb/slurmrestd.service /etc/systemd/system/
play slurm restart -v
