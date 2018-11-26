How to install Arch Linux on a PC
=================================

This guide explains how to install vanilla Arch Linux on a PC.

Prerequisites
-------------

- A PC or a laptop, with:
   - a USB port
   - wifi adapter
   - a HDD with contents that are no longer needed
- A USB stick with contents that are no longer needed.
- A PC with a working operating system and internet access. This may also be the machine we will install Arch Linux on. We will assume a Linux(-like) environment with 'curl' and 'dd'

The strategy is as follows:

1. On the working PC, create a bootable USB stick with an Arch-based distro on it
#. On the PC destined for Arch installation, boot from this live-USB
#. In a bash terminal, install Arch on the HDD with the commands found in this guide

Creating a live-USB
-------------------

On the working PC, download the .iso file of an Arch-based distro. ArchBang for instance:
::

  curl -LO https://sourceforge.net/projects/archbang/files/latest/download

Plug in the USB stick and write the .iso file on it. Here we assume the USB stick is device '/dev/sdb':
::

  sudo -i
  dd bs=4M if=archbang-rc-1810-x86_64.iso of=/dev/sdb status=progress oflag=sync && sync

Booting from the USB stick
--------------------------

Make sure the USB stick is plugged into the PC meant for Arch Linux, (Re-)boot the machine and enter the boot menu immediately at startup (press F9 or F12, or so).
In the boot menu, choose to boot from USB.
Once the OS has finished starting up, and if you're using wifi, set up your internet connection with the GUI. In the OpenBox desktop environment of ArchBang, this can be done in the lower right corner of the screen.

Then, open a bash prompt and set your keyboard layout, if needed
::

  setxkbmap be

Test your internet connection
::

  curl www.example.com

Go into a root prompt
::

  sudo -i

Make sure the system clock on the host OS is synced with NTP
::

  timedatectl set-ntp true

Install target OS
-----------------

TODO: wipe MBR due to FlexNet?

(Re-)partition the HDD. We assume the device is '/dev/sda'.
A possible partition layout is:

1. 13G for the root partition
#. The swap partiton. Size: twice the amount of RAM.
#. The /home partition. Takes up the rest of the space.

To create the partition table, follow the instructions in 'fdisk'.
::

  fdisk /dev/sda

Format the partitions
::

  mkfs.ext4 /dev/sda1
  mkswap /dev/sda2
  swapon /dev/sda2
  mkfs.ext4 /dev/sda3

Mount the partitions
::

  mkdir -p /mnt/targetfs
  mount /dev/sda1 /mnt/targetfs
  mkdir -p /mnt/targetfs/home
  mount /dev/sda3 /mnt/targetfs/home

Update the mirrorlist according to your location. Move the URL of a server near you to the top of the file.
::

  vi /etc/pacman.d/mirrorlist

Install some initial packages on the target system
::

  pacstrap /mnt/targetfs base grub sudo reflector

Generate fstab file
::

  genfstab -U /mnt/targetfs >> /mnt/targetfs/etc/fstab

'chroot' into the target filsystem
::

  arch-chroot /mnt/targetfs

Set your timezone
::

  ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime

Use UTC on the hardware clock
::

  hwclock --systohc --utc

Set the locale
::

  echo en_US.UTF-8 UTF-8 > /etc/locale.gen
  locale-gen
  echo LANG=en_US.UTF-8 > /etc/locale.conf

Set the keyboard layout on the target system
::

  echo KEYMAP=be-latin1 > /etc/vconsole.conf

Set the hostname
::

  echo tuma > /etc/hostname

Set hostname as an alias for localhost
::

  echo "127.0.0.1 tuma.localdomain tuma" >> /etc/hosts

Set the root password
::

  passwd

Add a non-root user, with 'sudo' rights
::

  groupadd sudoers && useradd -G sudoers -m bert

Allow group ‘sudoers’ to use sudo
::

  echo "%sudoers ALL=(ALL) ALL" >> /etc/sudoers

Set the password for this user
::

  passwd bert

Update & sort mirrorlist
::

  reflector --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

Install some necessary packages:
::

  pacman -Syu base-devel clang git vim tmux time zip unzip dialog dos2unix hwinfo haveged arch-install-scripts wpa_supplicant openssh knockd

Install some more optional packages:
::

  pacman -Syu lighttpd ffmpeg python-mako python-sphinx asciidoc

Install xorg-related packages:
::

  sudo pacman -Syu xorg-server xorg-xinit xorg-apps xorg-apps xorg-xfontsel xorg-fonts-misc unclutter dmenu ttf-inconsolata firefox

Install boot loader 'grub'
::

  grub-install --target=i386-pc /dev/sda

Edit the grub config file:
::

  sudoedit /etc/default/grub

Change the value of the variable into this:
::

  GRUB_CMDLINE_LINUX_DEFAULT=”quiet video=SVIDEO-1:d”

Re-configure grub
::

  sudo grub-mkconfig -o /boot/grub/grub.cfg

Leave the 'chroot' environment
::

  exit

Reboot into the installed OS
::

  reboot now

Set up networking
-----------------

Log in with the just-created non-root user.

List the network interfaces
::

  ip link

In the output you should see something like this:
::

  wlp16s0: <BROADCAST,MULTICAST> ...

Use a user-friendly GUI tool to setup a wireless connection
::

  sudo wifi-menu -o

Back in the bash terminal, test internet access. If this fails, wait a few seconds and try again.
::

  curl www.example.com

Enable the netctl profile, so that it auto-starts after reboot. If you named your profile 'mywifi' in the 'wifi-menu' tool, the command looks like this:
::

  sudo netctl enable mywifi

Set up the window manager
-------------------------

Enable the 'haveged' entropy daemon
::

   sudo systemctl start haveged
   sudo systemctl enable haveged

Auto-login at startup
::

   sudo systemctl edit getty@tty1

Add the lines:
::

   [Service]
   ExecStart=
   ExecStart=-/usr/bin/agetty --autologin bert --noclear %I $TERM

Download a customized version of 'dwm', 'st' and 'dmenu', and build & install them
::

  cd ~
  mkdir prj
  cd prj
  git clone https://github.com/bergoid/dwm.git
  cd dwm
  sudo ./rebuild

Edit .xinitrc
::

  vi ~/.xinitrc

And make sure it has the following contents:
::

  setxkbmap be
  unclutter -jitter 2 -noevents -root &
  exec dwm

Start dwm
::

  startx

Once you have installed 'dotfiles' from "Personal tools", dwm will auto-start at startup.

Personal tools
--------------

Install git repos
::

  mkdir ~/tools && cd ~/tools
  git clone https://github.com/bergoid/lswrappers.git
  git clone https://github.com/bergoid/rabot.git
  git clone https://github.com/bergoid/gt.git
  git clone https://github.com/bergoid/preppy.git
  git clone https://github.com/bergoid/avtools.git
  git clone https://github.com/bergoid/dotfiles.git
  dotfiles/install_dotfiles

youtube-dl without pacman:
::

  sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl

------------------------------------------------------------

TODO:

pikaur

disallow root login?

sshd config from VPS

acpi events: lid, power button
