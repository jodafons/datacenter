__all__ = ["Command",
           "Playbook"]


import os, traceback, json

from typing import List, Dict
from time import sleep
from pprint import pprint
from loguru import logger
from rich_argparse import RichHelpFormatter

def get_basepath() -> str:
    import playbooks
    return playbooks.__path__[0]

def get_cluster_config() -> Dict:
    with open(f"{get_basepath()}/templates/cluster.json",'r') as f:
        return json.load(f)

def get_host_path() -> str:
    return get_basepath()+"/templates/hosts"


class Command:
    def __init__(self, description : str):
        self.description = description
        self.command     = []

    def __add__(self, command : str):
        self.command.append(command)
        return self
    
    def __call__(self):
        return ' && '.join(self.command)


    
class Playbook:
  
    def __init__(self, 
               host_path : str,
               dry_run   : bool=False,
               verbose   : bool=False,
               envs      : Dict = {"ANSIBLE_HOST_KEY_CHECKING":"False"}
               ):
        """
        Initializes the Ansible class with the specified parameters.

        Parameters:
        ----------
        host_path : str
            The path to the Ansible hosts file.
        dry_run : bool, optional
            If True, the operations will be simulated without making any changes. Default is False.
        verbose : bool, optional
            If True, enables verbose output for debugging purposes. Default is False.
        envs : Dict, optional
            A dictionary of environment variables to set for the Ansible execution. 
            Default is {"ANSIBLE_HOST_KEY_CHECKING": "False"}.

        Attributes:
        ----------
        dry_run : bool
            Stores the dry_run flag.
        verbose : bool
            Stores the verbose flag.
        envs : Dict
            Stores the environment variables.
        """
        self.host_path = host_path
        self.dry_run   = dry_run
        self.verbose   = verbose
        self.envs      = envs


    def ping(self, hosts : str ):
        command = f"{self.__preexec} && ansible {hosts} -m ping -v -i {get_host_path()}"
        os.system(command)

    def run_shell(self, 
                  host_group  : str, 
                  command     : Command, 
                  script      : str="shell.yaml"
                ) -> bool:
        
        params = f"description='{command.description}' "
        params+= f"hosts={host_group} "
        params+= f"command='{command()}' "
        return self.run(script, params)

    def run(self, script: str, params: Dict[str,str]) -> bool:
            """ 
            Executes an Ansible playbook with the specified script and parameters.

            This method constructs a command to run an Ansible playbook using the 
            provided script and parameters. It sets up the necessary environment 
            variables and handles the execution of the command. If verbose mode is 
            enabled, additional output will be printed.

            Args:
                script (str): The name of the Ansible playbook script to execute.
                params (str): The parameters to pass to the Ansible playbook.

            Returns:
                bool: True if the command was executed successfully, False otherwise.

            Raises:
                Exception: If there is an error during command execution.
            """
            script = f"{get_basepath()}/yaml/{script}"
            hosts  = get_host_path()
            preexec = " && ".join([f"export {key}={value}" for key, value in self.envs.items()])
            params = " ".join([f"{key}={value}" for key, value in params.items()])
            command = f'{preexec} && ansible-playbook -i {hosts} {script} -e "{params}"'
            if self.verbose:
                command += " -vv"
            print(command)
            try:
                if not self.dry_run:
                    os.system(command)
                return True
            except:
                traceback.print_exc()
                return False

