__all__ = []

import os, json

from typing import Dict
from rich_argparse import RichHelpFormatter

def get_argparser_formatter():
  RichHelpFormatter.styles["argparse.args"]     = "green"
  RichHelpFormatter.styles["argparse.prog"]     = "bold grey50"
  RichHelpFormatter.styles["argparse.groups"]   = "bold green"
  RichHelpFormatter.styles["argparse.help"]     = "grey50"
  RichHelpFormatter.styles["argparse.metavar"]  = "blue"
  return RichHelpFormatter

def get_cluster_config() -> Dict:
    data_path = os.environ.get("NOVACULA_DATA_PATH")
    with open(f"{data_path}/cluster.json",'r') as f:
        return json.load(f)

def get_host_path() -> str:
    data_path = os.environ.get("NOVACULA_DATA_PATH")
    return f"{data_path}/hosts"

def get_playbook_path() -> str:
    playbook_path =os.environ.get("NOVACULA_PLAYBOOK_PATH")
    return f"{playbook_path}/playbooks"

def get_master_key() -> str:
    return os.environ.get("CLUSTER_MASTER_KEY", "")
    