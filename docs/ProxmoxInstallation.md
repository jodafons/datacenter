
# Proxmox Installation:

to install from a PVE 8.1 live USB stick by doing this :

- Boot from USB choosing the UEFI entry in the boot menu
- Move the cursor of the TUI installer option
- Press "e" to edit, replace "vga=xxx" at the end of the line with "nomodeset"
- Press Ctrl-X to boot with your changes

## Bios Setup:

Inside of the bios motherboard, search for these features:

- The feature `Intel Virtualization Technology` should be enabled.
- The feature `VT-d` should be enabled.


## Configure GPU Passthrough Inside Proxmox Shell (Only for GPU nodes):


Find the PCI address of the GPU Device. The following command will show the PCI address of the GPU devices in Proxmox server:

```
lspci -nnv | grep VGA
```

Find the GPU you want to passthrough in result ts should be similar to this:

```
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU104 [GeForce RTX 2080 SUPER] [10de:1e81] (rev a1) (prog-if 00 [VGA controller])
```

What we are looking is the PCI address of the GPU device. In this case it's `01:00.0`.
`01:00.0` is only a part of of a group of PCI devices on the GPU.
We can list all the devices in the group `01:00` by using the following command:


```
lspci -s 01:00
```

The usual output will include VGA Device and Audio Device. In my case, we have a USB Controller and a Serial bus controller:

```
01:00.0 VGA compatible controller: NVIDIA Corporation TU104 [GeForce RTX 2080 SUPER] (rev a1)
01:00.1 Audio device: NVIDIA Corporation TU104 HD Audio Controller (rev a1)
01:00.2 USB controller: NVIDIA Corporation TU104 USB 3.1 Host Controller (rev a1)
01:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU104 USB Type-C UCSI Controller (rev a1)
```

Now we need to get the id's of those devices. We can do this by using the following command:
```
lspci -s 01:00 -n
```

The output should look similar to this:

```
03:00.0 0300: 10de:1e81 (rev a1)
03:00.1 0403: 10de:10f8 (rev a1)
03:00.2 0c03: 10de:1ad8 (rev a1)
03:00.3 0c80: 10de:1ad9 (rev a1)
```

What we are looking are the pairs, we will use those id to split the PCI Group to separate devices.

```
10de:1e81,10de:10f8,10de:1ad8,10de:1ad9
```

Now it's time to edit the `grub` configuration file.

```
nano /etc/default/grub
```

Find the line that starts with `GRUB_CMDLINE_LINUX_DEFAULT`. Then change it to look like this (Intel CPU example) and replace `vfio-pci.ids=` with the ids for the GPU you want to passthrough:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on pcie_acs_override=downstream,multifunction initcall_blacklist=sysfb_init video=vesa:off vfio-pci.ids=10de:1e81,10de:10f8,10de:1ad8,10de:1ad9 vfio_iommu_type1.allow_unsafe_interrupts=1 kvm.ignore_msrs=1 modprobe.blacklist=radeon,nouveau,nvidia,nvidiafb,nvidia-gpu"
```

Save the config changed and then update GRUB.

```
update-grub
```

Next we need to add `vfio` modules to allow PCI passthrough.
Edit the `/etc/modules` file.

```
nano /etc/modules
```

Add the following line to the end of the file:

```
# Modules required for PCI passthrough
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

Save and exit the editor. Update configuration changes made in your `/etc` filesystem

```
update-initramfs -u -k all
```

and reboot the proxmox server.


Verify that IOMMU is enabled

```
dmesg | grep -e DMAR -e IOMMU
```

There should be a line that looks like `DMAR: IOMMU` enabled. If there is no output, something is wrong.

```
[0.000000] Warning: PCIe ACS overrides enabled; This may allow non-IOMMU protected peer-to-peer DMA
[0.067203] DMAR: IOMMU enabled
[2.573920] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[2.580393] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[2.581776] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
```

Check that the GPU is in a separate IOMMU Group by using the following command:

```
#!/bin/bash
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;
```

Now your Proxmox host should be ready to GPU passthrough!


## Add Storage:

Go to storage at datacenter three. Than click on add and select the NFS plugin. After, use the follow configuration to attach the storage.

- ID: storage01
- server: 10.1.1.202
- location: /volume1/proxmox
- Content: Disk, ISO, backup and snipped.

Than, click on add to propagate to the entire cluster.

