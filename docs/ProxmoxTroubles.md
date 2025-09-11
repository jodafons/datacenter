
# Proxmox Troubles:

Use this document to include all troubles or useful commands related to the proxmox configuration.

## Cluster Creation:

Choose some node to be the center node and open a `ssh` connection with this node (e.g: 10.1.1.110).

```
ssh root@caloba-v01.lps.ufrj.br
```

and create the cluster with

```
pvecm create caloba
```

## Cluster Node Registration:

For each new node you need to type the register command and point
to any `IP` node inside of the new cluster
```
pvecm add 10.1.1.101
```

**NOTE** For some reason the cluster dont work well if you have more than 10 nodes inside. To avoid this, we created clusters with 10 nodes. Currentally, we have two sub-clusters (with same name) inside of the lab.

## Reset Cluster Configuration:

For each node, you need to type the follow commands:

```
systemctl stop pve-cluster corosync
pmxcfs -l
rm -rf /etc/corosync/*
rm -rf /etc/pve/corosync.conf
killall pmxcfs
systemctl start pve-cluster
rm -rf /etc/pve/nodes/*
```
