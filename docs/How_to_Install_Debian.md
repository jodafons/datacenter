# Debian Installation Guide for a Slurm Worker Node

This guide provides a detailed, step-by-step walkthrough for installing the Debian operating system on a new node, specifically configured to function as a Slurm worker. Follow these instructions carefully during the installation process. You can download Debian [here](https://drive.google.com/file/d/1YNPPO5Ssl5tpM_stVRoTBEz2mrpjlqD_/view?usp=share_link). Follow the instructions to create a bootable pendrive [here](How_to_create_bootable_pendrive.md).

---

### Installation Steps

1.  **Boot from Installation Media:** Insert your Debian installation media (USB drive or DVD) and boot the machine. Select `Install`.

2.  **Language and Location:**
    * **Language:** Choose `English`.
    * **Location:** Select `Other`.
    * **Continent:** Select `South America`.
    * **Country:** Choose `Brazil`.
    * **Locales:** Select `United States`.
    * **Keyboard:** Select `American English`.

3.  **Network Configuration:**
    * **Hostname:** Enter `slurm-worker`.
    * **Domain:** Enter `lps.ufrj.br`.

4.  **User and Password Setup:**
    * **Root Password:** Leave this blank and continue. Do this a second time when prompted.
    * **Full Name:** Enter `cluster`.
    * **Username:** Enter `cluster`.
    * **User Password:** Set a strong password. Re-enter it to confirm.

5.  **Time Zone:**
    * **Clock Configuration:** Select `Sao Paulo`.

6.  **Disk Partitioning:**
    * **Partition Disks:** Select `Manual`.
    * Select the hard disk to partition.
    * Choose `Yes` to create a new, empty partition table on the device.
    * Select the `FREE SPACE` option.
    * Choose `Create a new partition`.
    * For the size, simply continue with the default total size.
    * For the type, select `Primary`.
    * Select `Done setting up the partition`.
    * Choose `Finish partitioning and write changes to disk`.
    * When asked to return to the partitioning menu, select `No`.
    * Confirm by selecting `Yes` to write the changes to disk.

7.  **Package Manager:**
    * **Scan extra installation media?** Select `No`.
    * **Debian archive mirror country:** Select `Brazil`.
    * **Mirror:** Select `deb.debian.org`.
    * **HTTP proxy:** Leave this field blank.

8.  **Software Selection:**
    * **Package Usage Survey:** Select `No`.
    * **Choose Software to Install:** Navigate the list and select **only** `SSH server` and `standard system utilities`. All other options should be deselected.

9.  **GRUB Boot Loader:**
    * **Install the GRUB boot loader to your primary drive?** Select `Yes`.
    * **Device:** Select the device for boot loader installation, typically `/dev/sda` (the second option).

10. **Finalization:**
    * Click `Continue` to complete the installation. The machine will reboot automatically.

Upon reboot, your Debian OS will be installed and configured as a Slurm worker node.


-----

# LPS adminstrator page:

Back to the [main](https://sites.google.com/lps.ufrj.br/infra/início) page!

