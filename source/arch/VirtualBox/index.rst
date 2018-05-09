Installing Arch Linux in VirtualBox
-----------------------------------

1. Arch Linux .iso file
=======================

archlinux-2018.02.01-x86_64.iso
    from: https://archlinux.cu.be/iso/2018.02.01/archlinux-2018.02.01-x86_64.iso
    saved at: "M:\vm\iso\archlinux-2018.02.01-x86_64.iso"


2. VirtualBox:
==============

. This document applies to v5.2.6
    . Help/About VirtualBox
    . File/Check for updates

. in File/Preferences:
    . General: check vm default location: "M:\vm"
. in File/Host Network Manager:
    . Create host-only network
        . Set the IP address, e.g. : 192.168.236.2
        . Network mask : 255.255.255.0

. new vm
    . name: yeba
        . make sure "M:\vm\yeba" doesn't exist before creation of VM
    . type/version: arch linux 64 bit
    . memory 4096 MB
    . create virtual HD

    . press "create"

    . File size 30 GB
    . VDI
    . dynamically allocated

. "yeba" (powered off) appears in list of VMs

. yeba Settings:

    . General/Advanced: shared clipboard: bidirectional

    . System/Motherboard:
        . Boot order: Optical, Harddisk
        . Extended features:
            . disable I/O APIC
            . disable EFI
            . enable HW clock in UTC time

    . Storage:
        . IDE secondary master: "M:\vm\iso\archlinux-2018.02.01-x86_64.iso"
            . don't enable LiveCD/DVD
        . SATA: add hard disk
            . new hard disk
            . VDI, dynamically allocated, 100 GB
            . M:\vm\hdd\LargeData.vdi

    . Network:
        . Adapter 1 : NAT
        . Adapter 2 : Host-only, name: the one just created in File/Preferences

    . Shared Folders:
        . "C:\Bert\vm\pub"
        . "M:\mshare"
        . auto-mount, full access


3. From LiveCD to working root login:
=====================================

start VM

loadkeys be-latin1

Network should work:
    curl www.google.com

timedatectl set-ntp true

fdisk -l /dev/sda

fdisk /dev/sda
    --> n : new partition
    --> p : primary partition
    --> enter : partition #1
    --> enter : default first sector
    --> enter : default last sector
    --> w write partition table


mkfs.ext4 /dev/sda1

mount /dev/sda1 /mnt

Make sure nearest mirror is first in the list:

    vi /etc/pacman.d/mirrorlist

pacstrap /mnt base

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime

hwclock --systohc --utc

echo en_US.UTF-8 UTF-8 > /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

echo KEYMAP=be-latin1 > /etc/vconsole.conf

echo yeba > /etc/hostname

vi /etc/hosts
    --> add:
    127.0.0.1 yeba.localdomain yeba

passwd

pacman -Syu grub

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

exit

shutdown now

in settings of VM: Remove disk from virtual drive

start VM

    ****** snapshot : Fresh install ******


4. A one-user system:
=====================

useradd -m bert

groupadd sudoers

usermod -aG sudoers bert

passwd bert

enable NW-ing:
    systemctl enable dhcpcd@enp0s3.service
    systemctl start dhcpcd@enp0s3.service

check connection:
    curl www.google.com

pacman -Syu sudo

allow group 'sudoers' to use sudo (in conf file):

visudo

--> add line:
        %sudoers    ALL=(ALL) ALL

log out of root session:

    exit

log back in as bert

test if sudo:

    sudo -v

(after entering password should not output anything if all is well)

    ****** snapshot : User bert, NW OK ******


5. Virtualbox Guest Additions
=============================

Make sure your version of Virtualbox matches the version of the Guest Additions:

    . VirtualBox:
        . Help/About VirtualBox
        . File/Check for updates


    . Arch Linux guest OS:
        . pacman -Ss virtualbox-guest-utils

Install guest additions & hwinfo

    sudo pacman -Syu virtualbox-guest-utils hwinfo

    During installation, choose package:

        virtualbox-guest-modules-arch

    sudo systemctl enable vboxservice.service

        output:
            created symlink /etc/systemd/system/multi-user.target.wants/vboxservice.service
            -> /usr/lib/systemd/system/vboxservice.service.

    sudo systemctl start vboxservice.service

    sudo reboot now
    (login)

Grant access to shared folders

    sudo chmod 755 /media
    sudo usermod -aG vboxsf bert

Logout and -in for the latter change to take effect

    ****** snapshot : vbox guest additions ******


6. Lots of packages
===================

Install some necessary packages:

    sudo pacman -Syu base-devel clang git vim tmux time zip unzip dialog wget dos2unix hwinfo openssh knockd lighttpd ffmpeg python-mako python-sphinx asciidoc

Install xorg-related packages:

    sudo pacman -Syu xorg-server xorg-xinit xorg-apps xorg-apps xorg-xfontsel xorg-fonts-misc unclutter dmenu ttf-dejavu ttf-inconsolata adobe-source-code-pro-fonts

The 2 previous commands can be combined by pasting all package names in a text file in a vboxsf shared folder and running:

    sudo pacman -Syu - < /media/sf_pub/packages.txt

Make the 'vi' command start 'vim':

    sudo mv /usr/bin/vi /usr/bin/vi_BAK
    sudo ln -s /usr/bin/vim /usr/bin/vi



            Install dwm from AUR:

                curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/st.tar.gz
                curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/dwm.tar.gz

                tar xzvf st.tar.gz
                tar xzvf dwm.tar.gz

                cd st && makepkg -si && cd -
                cd dwm && makepkg -si && cd -

    ****** snapshot : Packages installed ******


7. Set up xorg, dwm
===================

vim ~/.xinitrc

    VBoxClient --display --clipboard
    setxkbmap be
    exec dwm

startx

    dwm starts up
    alt-enter to open st session
    show all possible screen resolutions:
        xrandr

    dwm -v
        dwm-6.1

    st -v
        st 0.7

    The latter versions are identical to the effie setup


    shutdown vm

    Windows Command Prompt:

        VBoxManage setextradata "yeba" "CustomVideoMode1" "1600x900x24"

    start vm

    sudoedit /etc/default/grub
        GRUB_CMDLINE_LINUX_DEFAULT="quiet video=1600x900"

    sudo grub-mkconfig -o /boot/grub/grub.cfg

    Auto-login on TTY1:

        sudo systemctl edit getty@tty1

        add lines:

            [Service]
            ExecStart=
            ExecStart=-/usr/bin/agetty --autologin bert --noclear %I $TERM



8. Personal tools and config
============================

    mkdir ~/tools && cd ~/tools
    git clone https://github.com/bergoid/lswrappers.git
    git clone https://github.com/bergoid/rabot.git
    git clone https://github.com/bergoid/gt.git
    git clone https://github.com/bergoid/preppy.git
    git clone https://github.com/bergoid/avtools.git
    git clone https://github.com/bergoid/dotfiles.git
    dotfiles/install_dotfiles


    Do manually:

        ~/tools/misc
        ~/.gtpresets
        ~/.ssh

youtube-dl without pacman:

    sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl

sudo pacman -Syu knockd reflector

    Update mirrorlist:

        sudo reflector --age 6 --fastest 64 --protocol https --sort rate --save /etc/pacman.d/mirrorlist


    Set remote URLS to ssh protocol:
        git remote set-url origin github_bergoid:bergoid/anthos.git
        etc ...

    ****** snapshot : Xorg, dwm, personal tools & config ******

    Copy from effie:
        ~/notes.txt
        ~/cheatsheet.txt


9. Set up webserver and host->guest connectivity
================================================

/home/bert/prj/webserver contains:
    etc/lighttpd.conf
    www/index.html

sudo -i
    cd /srv && rm -rf *
    mkdir log
    ln -s /home/bert/prj/webserver repo
    ln -sf /etc/lighttpd.conf /srv/repo/etc/lighttpd.conf
    chmod 755 /home/bert

/home/bert/prj/webserver/etc/lighttpd.conf:
    server.modules = (
        "mod_access",
        "mod_accesslog",
        )

    server.port = 80
    server.username = "http"
    server.groupname = "http"
    server.document-root = "/srv/repo/www"
    server.errorlog = "/srv/log/error.log"
    accesslog.filename = "srv/log/access.log"
    dir-listing.activate = "enable"
    index-file.names = ( "index.html" )
    mimetype.assign = (
                    ".html" => "text/html",
                    ".txt" => "text/plain",
                    ".css" => "text/css",
                    ".js" => "application/x-javascript",
                    ".jpg" => "image/jpeg",
                    ".jpeg" => "image/jpeg",
                    ".gif" => "image/gif",
                    ".png" => "image/png",
                    "" => "application/octet-stream"
                    )

/home/bert/prj/webserver/www/index.html:
    Hello there!

sudo systemctl start lighttpd.service
sudo systemctl status lighttpd.service
sudo systemctl enable lighttpd.service

curl localhost

Configure static IP address 192.168.236.20 and gateway 192.168.236.2:

sudo ip link set enp0s8 down

sudoedit /etc/netctl/enp0s8
    Description='yeba static ip address'
    Interface=enp0s8
    Connection=ethernet
    IP=static
    Address=('192.168.236.20/24')
    Gateway=('192.168.236.2')

sudo netctl start enp0s8
sudo netctl enable enp0s8

--> Visit 192.168.236.20 with browser on host OS

    ****** CURRENT STATE ******


10. Further config
==================

TODO:

dwm monocle mode

autostart tmux 2 panes in every st terminal

tmux scrollback

change xorg clipboard

set vim yank buffer to xorg clipboard

bidir clipboard host/guest OK?
