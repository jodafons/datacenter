#!/bin/python

import argparse
import sys

from novacula                   import get_argparser_formatter
from novacula.proxmox.cluster   import Cluster, cluster_create_parser, cluster_destroy_parser, cluster_reboot_parser, cluster_ping_parser
from novacula.proxmox.vm        import VM, vm_create_parser, vm_destroy_parser,  vm_ping_parser

def create_vm(args) -> VM:
  return VM( args.name, 
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
        vm = create_vm(args)
        if args.option == "create":
            vm.create()
        elif args.option == "destroy":
            vm.destroy()
        elif args.option == "ping":
          vm.ping()
    
      

def run():

    parser = build_argparser(custom=True)
    if len(sys.argv)==1:
        print(parser.print_help())
        sys.exit(1)
    args = parser.parse_args()
    run_parser(args)

if __name__ == "__main__":
  run()