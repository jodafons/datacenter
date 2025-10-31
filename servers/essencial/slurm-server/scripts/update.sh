
# recopy everything to SLURM
echo "recopy..."
sudo cp files/slurm/slurm.conf /etc/slurm/
sudo cp files/slurm/slurmdbd.conf /etc/slurm
sudo chmod 600 /etc/slurm/slurmdbd.conf
sudo chown -R slurm /etc/slurm
sudo cp files/slurm/slurmdbd.service /etc/systemd/system/
sudo cp files/slurm/slurmctld.service /etc/systemd/system/
sudo cp files/slurm/slurm.conf /mnt/market_place/slurm_build
#sudo cp files/slurmweb/agent.ini  /etc/slurm-web/
#sudo cp files/slurmweb/gateway.ini  /etc/slurm-web/
#sudo cp files/slurmweb/policy.ini  /etc/slurm-web/
#sudo cp files/slurmweb/gateway.yml /usr/share/slurm-web/conf/ # bugfix
#sudo cp files/slurmweb/slurmrestd.service /etc/systemd/system/



sudo cp /etc/munge/munge.key /mnt/market_place/slurm_build
sudo systemctl daemon-reload
sudo systemctl start munge
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld
sudo systemctl enable slurmrestd.service
sudo systemctl start slurmrestd.service
#systemctl enable slurm-web-agent.service
#systemctl enable slurm-web-gateway.service
#systemctl start slurm-web-agent.service
#systemctl start slurm-web-gateway.service
sudo scontrol reconfigure

#systemctl status slurmctld
#play slurm restart -v
