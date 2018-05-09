Installing Arch Linux on VPS
============================

1. Base system
..............

Create VPS, pick Debian 9.3 as OS.
    --> didn't work 2nd time, stuck in 1st reboot
        picked centos and worked

Copy bootstrap files from M:\vm\iso\vps2arch to M:\mshare\vps2arch
and cd into the latter folder.

Upload bootstrap files to the newly created VPS:

    scp * root@IP_ADDRESS:

Log into the VPS

chmod +x vps2arch
mv * / && cd /
./vps2arch
echo HOSTNAME > /etc/hostname
sync; reboot -f


2. Create user
..............

useradd -m bert
groupadd sudoers
usermod -aG sudoers bert
passwd bert

pacman -Syu sudo vim ufw knockd lighttpd git

allow group 'sudoers' to use sudo (in conf file):

    echo '%sudoers ALL=(ALL) ALL' > /etc/sudoers

use 'vim' as 'vi':

    mv /usr/bin/vi /usr/bin/vi_BAK && ln -s /usr/bin/vim /usr/bin/vi


3. sshd config
..............

On the client:

    ssh-copy-id bert@IP_ADDRESS

On the server:

    vi /etc/ssh/sshd_config
        LogLevel VERBOSE
        PermitRootLogin no
        PubkeyAuthentication yes
        PasswordAuthentication no
        AuthorizedKeysFile .ssh/authorized_keys
        ChallengeResponseAuthentication no
        UsePAM yes
        AllowUsers bert

Add 5s delay to failed login attempts:

    bash -c "echo auth optional pam_faildelay.so delay=5000000 >> /etc/pam.d/system-login"

reboot needed for future ufw config:

    reboot now


4. ufw, knockd
..............

ssh bert@IP_ADDRESS

sudo -i
    ufw default deny
    ufw allow 22
    ufw allow 80,443/tcp
    ufw enable

    vi /etc/knockd.conf
        [options]
              logfile = /var/log/knockd.log
        [SSH]
              sequence    = PORT1, PORT2, ..., PORTN
              seq_timeout = 5
              start_command = ufw allow from %IP% to any port 22
              tcpflags    = syn
              cmd_timeout   = 10
              stop_command  = ufw delete allow from %IP% to any port 22

    systemctl enable ufw.service
    systemctl start ufw.service

    systemctl enable knockd.service
    systemctl start knockd.service

    ufw delete allow 22

5. Customization
................

Create dotfiles & tools:

    mkdir ~/tools && cd ~/tools
    git clone https://github.com/bergoid/lswrappers.git
    git clone https://github.com/bergoid/rabot.git
    git clone https://github.com/bergoid/gt.git
    git clone https://github.com/bergoid/preppy.git
    git clone https://github.com/bergoid/dotfiles.git
    dotfiles/install_dotfiles
    echo hostnameColour=27 > ~/.localConfig

Customize root env:

    sudo -i
    sudo -i
        ln -s /home/bert/.tmux.conf .tmux.conf
        ln -s /home/bert/tools/dotfiles/.vim/ .vim
        ln -s /home/bert/tools/ tools
        ln -s /home/bert/.bash_profile .bash_profile
        ln -s /home/bert/.bashrc .bashrc


6. spigot server
................

Enable AUR:
    sudo pacman -Syu base base-devel
    mkcd ~/aur

Install JRE:
    git clone https://aur.archlinux.org/jre.git
    cd jre
    makepkg -si

Install bukkit/spigot:

    mkcd ~/mc
    curl "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" -o BuildTools.jar
    java -jar BuildTools.jar

sudo pacman -Syu tmux dialog

vi /etc/locale.gen
    --> Uncomment:  'en_US.UTF-8 UTF-8'

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

sudo ufw allow 24680

Removed jre9:

sudo pacman -Rs jre

Install jre8:
    cd ~/aur
    git clone https://aur.archlinux.org/jre8.git
    cd jre8
    makepkg -si


    ****** CURRENT STATE ******
