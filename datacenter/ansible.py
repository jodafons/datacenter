__all__ = ["Command",
           "Playbook"]


import os, traceback, tempfile

from typing import Dict
from datacenter import get_host_path, get_playbook_path,get_master_key



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
               host_path : str=get_host_path(),
               dry_run   : bool=False,
               verbose   : bool=False,
               envs      : Dict = {"ANSIBLE_HOST_KEY_CHECKING":"False"},
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

    def ping_hosts(self, hosts : str ):
        preexec = " && ".join([f"export {key}={value}" for key, value in self.envs.items()])

        with tempfile.TemporaryDirectory() as temp_dir:
                print(f"Temporary directory created at: {temp_dir}")
                # Define the path for the file within the temporary directory
                file_path = os.path.join(temp_dir, "hosts")

                with open(file_path, 'w') as f:
                    with open(self.host_path, mode='r') as f_original:
                        for line in f_original.readlines():
                            f.write(line.replace("$CLUSTER_MASTER_KEY", get_master_key()) )
                    print(f.name)
                
                command = f'{preexec} && ansible {hosts} -m ping -v -i {file_path}'
                os.system(command)

    def run_shell(self, 
                  hosts       : str, 
                  command     : Command, 
                  script      : str="shell.yaml"
                ) -> bool:
        params = {
            "command": f"'{command()}'",
            "description": f"'{command.description}'",
        }
        return self.run(script, hosts, params)

    def run(self, script: str, hosts : str,  params: Dict[str,str]={}) -> bool:
           
            script  = f"{get_playbook_path()}/{script}"
            params  = {"hosts": hosts, **params}
            preexec = " && ".join([f"export {key}={value}" for key, value in self.envs.items()])
            params  = " ".join([f"{key}={value}" for key, value in params.items()])

            ok = False

            with tempfile.TemporaryDirectory() as temp_dir:
                print(f"Temporary directory created at: {temp_dir}")
                # Define the path for the file within the temporary directory
                file_path = os.path.join(temp_dir, "hosts")

                with open(file_path, 'w') as f:
                    with open(self.host_path, mode='r') as f_original:
                        for line in f_original.readlines():
                            f.write(line.replace("$CLUSTER_MASTER_KEY", get_master_key()) )
                    print(f.name)
                
                command = f'{preexec} && ansible-playbook -i {file_path} {script} -e "{params}"'


                if self.verbose:
                    command += " -vv"
                print(command)
                try:
                    if not self.dry_run:
                        os.system(command)
                    ok = True
                except:
                    traceback.print_exc()
            return ok        


