__all__ = ["Slurm"]


import argparse

from time               import sleep
from typing             import Union, Dict
from datacenter.ansible import Playbook, Command
from datacenter         import get_cluster_config
from datacenter         import get_argparser_formatter


class Slurm(Playbook):
  
    def __init__(self,
               dry_run  : bool=False,
               verbose  : bool=False,
               ):
        Playbook.__init__(self, dry_run=dry_run, verbose=verbose)
        self.cluster_config = get_cluster_config()
    
    def run_script_on_all(self, command : Command ) -> bool:
        self.run_shell("vm", command)
  
    def run_script_on_master(self, command : Command ) -> bool:
        self.run_shell("slurmctld", command)

    def run_script_on_entrypoint(self, command : Command ) -> bool:
        self.run_shell("login", command)

  
    def ping(self):
        self.ping_hosts("vm")

   
    #
    #
    #
    def restart(self):

        command = Command("Restart slurm control...")
        command+= "cp /etc/munge/munge.key /mnt/market_place/slurm_build"
        command+= "sudo systemctl daemon-reload"
        command+= "sudo systemctl start munge"
        command+= "sudo systemctl enable slurmdbd"
        command+= "sudo systemctl start slurmdbd"
        command+= "sudo systemctl enable slurmctld"
        command+= "sudo systemctl start slurmctld"
        #command+= "systemctl enable slurmrestd.service"
        #command+= "systemctl start slurmrestd.service"
        #command+= "systemctl enable slurm-web-agent.service"
        #command+= "systemctl enable slurm-web-gateway.service"
        #command+= "systemctl start slurm-web-agent.service"
        #command+= "systemctl start slurm-web-gateway.service"
        command+= "sudo scontrol reconfigure"
        self.run_script_on_master(command)
    
        command = Command("Update munge key...")
        command+= "cp /mnt/market_place/slurm_build/munge.key /etc/munge/"
        command+= "chown munge:munge /etc/munge/munge.key"
        command+= "chmod 400 /etc/munge/munge.key"
        command+= "systemctl enable munge"
        command+= "systemctl restart munge"
        command+= "systemctl enable slurmd"
        command+= "systemctl restart slurmd"
        self.run_script_on_all(command)
    
        command = Command( "Update munge key...")
        command+= "cp /mnt/market_place/slurm_build/munge.key /etc/munge/"
        command+= "chown munge:munge /etc/munge/munge.key"
        command+= "chmod 400 /etc/munge/munge.key"
        command+= "systemctl enable munge"
        command+= "systemctl restart munge"
        self.run_script_on_entrypoint(command)
  
    

      

#
# Parsers
#

def common_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                      help = "dry run...")
  parser.add_argument('-v','--verbose', action='store_true', dest='verbose', required = False, 
                      help = "Set as verbose output.")
  return parser

def slurm_restart_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  return [common_parser(),parser]


