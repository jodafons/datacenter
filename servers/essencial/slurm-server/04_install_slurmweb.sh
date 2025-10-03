cp files/slurmweb/slurmrestd.service /etc/systemd/system
systemctl daemon-reload
systemctl enable slurmrestd.service
systemctl start slurmrestd.service



curl -sS https://pkgs.rackslab.io/keyring.asc | gpg --dearmor | tee /usr/share/keyrings/rackslab.gpg > /dev/null
cp files/slurmweb/rackslab.sources /etc/apt/sources.list.d/
apt update
apt install -y slurm-web-agent slurm-web-gateway

sudo ufw allow from any to any port 5011
sudo ufw allow from any to any port 5012

cp files/slurmweb/agent.ini  /etc/slurm-web/
cp files/slurmweb/gateway.ini  /etc/slurm-web/
cp files/slurmweb/policy.ini  /etc/slurm-web/
cp files/slurmweb/gateway.yml /usr/share/slurm-web/conf/ # bugfix
/usr/libexec/slurm-web/slurm-web-gen-jwt-key
systemctl enable slurm-web-agent.service
systemctl enable slurm-web-gateway.service



#journalctl --unit slurm-web-agent.service
#journalctl --unit slurm-web-gateway.service