Headless install of Arch Linux on Raspberry Pi Zero W
=====================================================

Prerequisites
-------------

Arch Linux, with the following packages:
    dosfstools
    wpa_supplicant

Micro SD card

USB stick with slot for Micro SD Card

Raspberry Pi Zero W


Create an Arch Linux ARM system
-------------------------------

TODO : chroot binfmt qemu


Partition Micro SD Card
-----------------------

In Linux, list the available devices:
::

    sudo fdisk -l

If Linux is running inside VirtualBox, consult the list of devices in:  Devices>USB

Insert the Micro SD card in the USB adapter, and insert the adapter in a USB port.

If Linux is running inside VirtualBox, look up & select the new device that appeared in Devices>USB

List the available devices again:
::

    sudo fdisk -l

The device that was added to the list is the Micro SD card.


Useful commands
---------------

Save existing partition layout:
::

    sudo sfdisk -d /dev/sdc > part_layout.txt

Partition a card according to a saved layout:
::

    sudo sfdisk /dev/sdc < part_layout.txt

Delete all partitions:
::

    sudo sfdisk --delete /dev/sdc

References
----------

https://archlinuxarm.org/platforms/armv6/raspberry-pi

https://ladvien.com/installing-arch-linux-raspberry-pi-zero-w/

https://wiki.debian.org/QemuUserEmulation

http://blog.thijsbroenink.com/2015/10/emulate-file-system-with-different-architecture/

https://raspberrypi.stackexchange.com/questions/165/emulation-on-a-linux-pc
