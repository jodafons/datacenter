# How to create a bootable USB drive on Linux?

#### Using the `dd` command (recommended for Linux)

This method is the most reliable and direct way to create a bootable USB drive from an ISO file. It's a command-line tool, so you need to be comfortable with the terminal.

1.  **Find the device name of your USB drive.**
    First, insert your USB drive and use the `lsblk` command to see all connected block devices. Your USB drive will likely be listed as something like `/dev/sdb` or `/dev/sdc`. Make sure you identify the correct device, as the next step will erase all data on it.

    ```bash
    lsblk
    ```

2.  **Unmount the USB drive.**
    If your system has automatically mounted the USB drive, you need to unmount it before writing to it. For example, if your USB is mounted at `/media/yourusername/USBNAME`, you would unmount it with:

    ```bash
    sudo umount /dev/sdX1  # Replace X with the correct letter for your drive
    ```

3.  **Write the ISO to the USB drive.**
    Now, use the `dd` command to write the ISO file to the USB drive. Replace `path/to/your/image.iso` with the path to your downloaded ISO file and `/dev/sdX` with the correct device name of your USB drive.

    ```bash
    sudo dd if=path/to/your/image.iso of=/dev/sdX bs=4M status=progress
    ```

      * `if`: Input file (the ISO).
      * `of`: Output file (the USB drive).
      * `bs=4M`: Sets the block size to 4 megabytes, which speeds up the process.
      * `status=progress`: Shows the progress of the operation.

4.  **Wait for the process to finish.**
    The command will take some time to complete, depending on the size of the ISO and the speed of your USB drive. When it's done, you'll be returned to the command prompt.

5.  **Sync the data.**
    It's a good practice to run `sync` to ensure all data is written to the drive.

    ```bash
    sync
    ```

#### Using graphical tools

If you prefer a graphical interface, you can use one of these tools:

  * **BalenaEtcher:** A cross-platform open-source tool that's very simple to use.
      * **Download:** [https://www.balena.io/etcher/](https://www.balena.io/etcher/)
  * **UNetbootin:** Another popular tool for creating bootable live USB drives.
      * **Download:** [https://unetbootin.github.io/](https://unetbootin.github.io/)

-----

# How to create a bootable USB drive on macOS?

#### Using the `dd` command (recommended for macOS)

Similar to Linux, the `dd` command is a powerful and effective way to create a bootable USB on macOS.

1.  **Find the disk identifier of your USB drive.**
    Insert your USB drive and open the Terminal. Use the `diskutil list` command to identify your drive. Look for an external drive with a size that matches your USB drive. It will be identified as something like `/dev/disk2` or `/dev/disk3`.

    ```bash
    diskutil list
    ```

2.  **Unmount the USB drive.**
    Before you can write to the drive, you must unmount it. Use the `diskutil unmountDisk` command, replacing `diskX` with your drive identifier.

    ```bash
    diskutil unmountDisk /dev/diskX
    ```

3.  **Write the ISO to the USB drive.**
    Now, use the `dd` command. On macOS, it's often more reliable to specify the device path with a 'raw' prefix (`r`). This bypasses certain caching, making the process faster.

    ```bash
    sudo dd if=/path/to/your/image.iso of=/dev/rdiskX bs=1m
    ```

      * `if`: Input file (the ISO).
      * `of`: Output file (the USB drive).
      * `bs=1m`: Sets the block size to 1 megabyte.

4.  **Wait for the process to finish.**
    The command will not show progress, but it will return to the command prompt when complete. This can take a while.

5.  **Eject the drive.**
    Once the command is finished, eject the drive to ensure all data has been written.

    ```bash
    diskutil eject /dev/diskX
    ```

#### Using graphical tools

  * **BalenaEtcher:** This is the most popular and user-friendly tool for macOS. It automates the entire process of writing an ISO to a USB drive.
      * **Download:** [https://www.balena.io/etcher/](https://www.balena.io/etcher/)



# LPS adminstrator page:

Back to the [main](https://sites.google.com/lps.ufrj.br/infra/início) page!
