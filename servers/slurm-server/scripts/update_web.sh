sudo cp files/slurmweb/agent.ini  /etc/slurm-web/
sudo cp files/slurmweb/gateway.ini  /etc/slurm-web/
#sudo cp files/slurmweb/policy.ini  /etc/slurm-web/
sudo cp files/slurmweb/gateway.yml /usr/share/slurm-web/conf/ # bugfix
sudo cp files/slurmweb/slurmrestd.service /etc/systemd/system/

sudo systemctl restart slurm-web-agent.service
sudo systemctl restart slurm-web-gateway.service
