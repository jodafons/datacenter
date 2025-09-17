__all__ = ["VM"]


import argparse

from time               import sleep
from typing             import Union
from datacenter.ansible import Playbook, Command
from datacenter         import get_cluster_config
from datacenter         import get_argparser_formatter




class VM(Playbook):
  
    def __init__(self,
               vm_name  : str,
               dry_run  : bool=True,
               verbose  : bool=False,
               ):
        Playbook.__init__(self, dry_run=dry_run, verbose=verbose)
        self.vm_name = vm_name
        self.cluster_config = get_cluster_config()
        self.vm_init_name = self.cluster_config['images']['hostname']

    def vm(self, key : str) -> Union[str,int]:
        return self.cluster_config['vm'][self.vm_name][key]

    def image(self) -> str:
        return self.cluster_config['images']['paths'][self.vm("image")]

    def ping(self):
        self.ping_hosts(self.vm_name)


    def run_shell_on_vm(self, 
                         command : Command,
                         ) -> bool:
        return self.run_shell(self.vm_name, command)
    

    def run_shell_on_host(self, 
                                 command : Command
                                 ) -> bool:
        vm_host = self.vm("host")
        return self.run_shell(vm_host, command)
    
    
    #
    #
    #


    def restore(self) -> bool:

        image      = self.image()    
        vmid       = self.vm("vmid")
        sockets    = self.vm("sockets")
        cores      = self.vm("cores")
        memory_mb  = self.vm("memory_mb")
        storage    = self.vm("storage")
        vm_name    = self.vm("vm_name") 

        command = Command("restore vm...")
        command+= f"qmrestore {image} {vmid} --storage {storage} --unique --force"
        command+= f"qm set {vmid} --name {vm_name} --sockets {sockets} --cores {cores} --memory {memory_mb}"
        command+= f"qm start {vmid}"
        return self.run_shell_on_host(command)
    
    
    def snapshot(self, name : str) -> bool:
        vmid  = self.vm("vmid")
        command = Command(f"snapshot vm {self.vm_name}...")
        command+= f"qm snapshot {vmid} {name}"
        return self.run_shell_on_host(command)


    def reboot(self) -> bool:
        vmid  = self.vm("vmid")
        command = Command(f"reboot vm {self.vm_name}...")
        command+= f"qm stop {vmid} && qm start {vmid}"
        return self.run_shell_on_host(command)
  
  
    def configure(self) -> bool:
        ip_address = self.vm("ip_address")
        script_http = "https://raw.githubusercontent.com/jodafons/datacenter/refs/heads/main/data/scripts/configure_network.sh" 
        script_name = script_http.split("/")[-1]
        command = Command(f"configure network on vm {self.vm_name}...")
        command+= f"wget {script_http} && bash {script_name} {self.vm_name} {ip_address}"
        params  = {
              "command"    : f"'{command()}'",
              "ip_address" : f"'{ip_address}'",
              "vm_name"    : self.vm_name,
        }
    
        return self.run("configure_network.yaml", self.vm_init_name, params)
    

    #
    # VM operations
    #
 
    def destroy(self) -> bool:
        vmid = self.vm("vmid")
        command = Command(f"destroy vm {self.vm_name}...")
        command+= f"qm stop {vmid} && qm destroy {vmid}"
        return self.run_shell_on_host(command)
     
  
    def create(self, snapname : str="base") -> bool:  
        print(f"restore image into the host...")  
        ok = self.restore()
        sleep(40)
        if not ok:
            return False
        print(f"configure network into {self.vm_name}")
        ok = self.configure()
        if not ok:
            return False    
        print("take a snapshot...")
        self.snapshot(snapname)
        return True

      

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

def vm_create_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser]

def vm_destroy_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser] 
  
def vm_ping_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser] 

