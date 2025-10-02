#!/bin/python

import argparse
import sys, re

from datacenter                   import get_argparser_formatter
from datacenter.proxmox.cluster   import Cluster, cluster_create_parser, cluster_destroy_parser, cluster_reboot_parser, cluster_ping_parser
from datacenter.proxmox.vm        import VM, vm_create_parser, vm_destroy_parser,  vm_ping_parser



def convert_string_to_range(s):
     """
       convert 0-2,20 to [0,1,2,20]
     """
     return sum((i if len(i) == 1 else list(range(i[0], i[1]+1))
                for i in ([int(j) for j in i if j] for i in
                re.findall(r'(\d+),?(?:-(\d+))?', s))), [])


def convert_name_in_list(s):
  name = re.match(r'([a-zA-Z]+)', s).group(1)
  return [ name+str(idx) for idx in convert_string_to_range(s)]


def create_vm(name : str, args) -> VM:
  return VM( name, 
             dry_run=args.dry_run,
             verbose=args.verbose)
  
def create_cluster(args) -> Cluster:
  return Cluster( args.name, 
                  dry_run=args.dry_run,
                  verbose=args.verbose)

def build_argparser():

    parser          = argparse.ArgumentParser(  formatter_class=get_argparser_formatter())
    mode            = parser.add_subparsers(dest='mode')
    
    cluster_parent = argparse.ArgumentParser( add_help=False,   formatter_class=get_argparser_formatter())
    option         = cluster_parent.add_subparsers(dest='option')
    option.add_parser("create"  , parents = cluster_create_parser()  ,help="",formatter_class=get_argparser_formatter())
    option.add_parser("destroy" , parents = cluster_destroy_parser() ,help="",formatter_class=get_argparser_formatter())
    option.add_parser("reboot"  , parents = cluster_reboot_parser()  ,help="",formatter_class=get_argparser_formatter())
    option.add_parser("ping"    , parents = cluster_ping_parser()    ,help="",formatter_class=get_argparser_formatter())

    mode.add_parser( "cluster", parents=[cluster_parent]             ,help="",formatter_class=get_argparser_formatter())

    vm_parent = argparse.ArgumentParser( add_help=False,   formatter_class=get_argparser_formatter())
    option = vm_parent.add_subparsers(dest='option')
    option.add_parser("create"    , parents = vm_create_parser()    ,help="",formatter_class=get_argparser_formatter())
    option.add_parser("destroy"   , parents = vm_destroy_parser()   ,help="",formatter_class=get_argparser_formatter())
    option.add_parser("ping"      , parents = vm_ping_parser()      ,help="",formatter_class=get_argparser_formatter())
    mode.add_parser( "vm"         , parents=[vm_parent]             ,help="",formatter_class=get_argparser_formatter())
    
    return parser
  
def run_parser(args):
    if args.mode == "cluster":
        cluster = create_cluster(args)
        if args.option == "create":
          cluster.create()
        elif args.option == "destroy":
          cluster.destroy()
        elif args.option == "reboot":
          cluster.reboot()
        elif args.option == "ping":
          cluster.ping()
    elif args.mode == "vm":

        names = convert_name_in_list(args.name)
        print(names)
        for name in names:
          print(name)
          vm = create_vm(name, args)
          if args.option == "create":
              vm.create()
          elif args.option == "destroy":
              vm.destroy()
          elif args.option == "ping":
            vm.ping()
    
      

def run():

    parser = build_argparser()
    if len(sys.argv)==1:
        print(parser.print_help())
        sys.exit(1)
    args = parser.parse_args()
    run_parser(args)

if __name__ == "__main__":
  run()