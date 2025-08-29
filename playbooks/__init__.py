__all__ = ["get_argparser_formatter", 
           "get_basepath", 
           "get_host_path",
           "get_cluster_config",
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


def get_argparser_formatter():
  RichHelpFormatter.styles["argparse.args"]     = "green"
  RichHelpFormatter.styles["argparse.prog"]     = "bold grey50"
  RichHelpFormatter.styles["argparse.groups"]   = "bold green"
  RichHelpFormatter.styles["argparse.help"]     = "grey50"
  RichHelpFormatter.styles["argparse.metavar"]  = "blue"
  return RichHelpFormatter
    
class Playbook:
  __preexec = "export ANSIBLE_HOST_KEY_CHECKING=False"

  def __init__(self, 
               dry_run   : bool=False,
               verbose   : bool=False,
               ):
    self.dry_run   = dry_run
    self.verbose   = verbose
    
  def ping(self, hosts : str ):
    command = f"{self.__preexec} && ansible {hosts} -m ping -v -i {get_host_path()}"
    os.system(command)
    
  def run_shell(self, 
                hosts       : str, 
                command     : str, 
                description : str="", 
                script      : str="shell.yaml"
              ) -> bool:
    
    params = f"description='{description}' "
    params+= f"hosts={hosts} "
    params+= f"command='{command}' "
    return self.run(script, params)

  def run(self, script : str, params : str) -> bool:
    script = f"{get_basepath()}/yaml/{script}"
    hosts  = get_host_path()
    command=f'{self.__preexec} && ansible-playbook -i {hosts} {script} -e "{params}"'
    if self.verbose:
      command+=" -vv"
    logger.info(command)
    try:
      if not self.dry_run:
        os.system(command)
      return True
    except:
      traceback.print_exp()
      return False


from . import playbooks
__all__.extend( playbooks.__all__ )
from .playbooks import *

