echo "Ping all nodes..."
ping.sh
sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld
echo "reset slurm configuration for all nodes..."
ansible-playbook -i $LPS_CLUSTER_HOSTS $SLURM_PLAYBOOKS/restart_slurmd.yaml -e "hostgroup=vm"
