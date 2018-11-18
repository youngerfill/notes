===========
Cheat Sheet
===========

.. highlight:: bash


.. contents::
   :backlinks: none


Check folder size:
==================
::

    du -sh foldername/

Clear trash folder (Ubuntu & friends):
======================================
::

    rm -rf ~/.local/share/Trash/files ~/.local/share/Trash/info


Arch Linux guest VM in VirtualBox:
==================================

Restore networking:
-------------------
::

    sudo ip link set enp0s8 down && sudo ip link set enp0s8 up && curl www.google.com

Mount USB drive
---------------

Before inserting the USB drive, show list of devices:
::

    sudo lsblk -f

Insert USB drive, and select device in VirtualBox GUI menu ( Devices > USB > ... )

In VM, show list of devices again to find the DEVICENAME of the new device:
::

    sudo lsblk -f

Mount the device:
::

    sudo -i
    mkdir /mnt/usbstick
    mount /dev/DEVICENAME /mnt/usbstick

wget
====

Mirror site:
::

      wget -mkE http://www.example.com

Mirror subdirectory of website:
::

     wget -mkE -np http://www.example.com/subdir/

Mirror full web page:
::

      wget -pkE -np -nH -nd http://www.example.com/page.html
      wget -np -k -p -nd -nH -H -E http://www.example.com/page.html


Related: extract URLs ('http://...' ones) from HTML file:
::

    sed 's/<a href="/\n/g' index.html | sed 's/">/\n/g' | grep "^http:" | sort -u



youtube-dl
==========

Download video from YouTube:
::

    youtube-dl "URL"


Download audio from YouTube:
::

    youtube-dl -x -o "%(title)s.%(ext)s" "URL"

Download audio & convert to mp3:
::

    youtube-dl -x --audio-format "mp3" -o "%(title)s.%(ext)s" "URL"

Download videos listed in urls.txt:
::

    cat urls.txt | xargs -I{} youtube-dl "{}"


Download audio of videos listed in urls.txt:
::

    cat urls.txt | xargs -I{} youtube-dl -x -o "%(autonumber)s - %(title)s.%(ext)s" "{}"


Update program:
::

    sudo youtube-dl -U

zenity
======

Zenity menu:
::

    zenity --width=640 --height=480 --list --column "Number" --column "Name" --title="Numbers and their names" --text="" 1 one 2 two 3 three


Zenity menu from textfile, 1st line is the title, 2nd line are the column names, separated by tab characters, rest of the file are line entries separated by newlines, divided in columns by tab characters:
::

    eval zenity --width=640 --height=480 --list $(cat menu.txt | sed '2q;d' | tr '\t' '\n' | sed 's/^/--column\ \"/' | sed 's/$/\"/' | tr '\n' ' ') --title=$(cat menu.txt | head -n 1 | sed 's/^/\"/' | sed 's/$/\"/' | tr '\n' ' ') $(cat menu.txt | tail -n +3 | tr '\t' '\n' | sed 's/^/\"/' | sed 's/$/\"/' | tr '\n' ' ')


tail
====
::

    tail -f /var/log/messages


mount
=====

Mount ext3 partition:
::

    sudo mkdir /media/bigpart
    sudo mount /dev/sda4 /media/bigpart -t ext3



bash
====

Redirection in bash
-------------------

Redirect stderr of command to stdout:
::

    ls 2>&1

Don't output anything:
::

    ls > /dev/null 2>&1

Echo to stderr:
::

    echo Hello >&2

Iterate over output of command, one line per iteration, and write output to a file:
::

    while read line; do
        echo Another line: $line
    done < <(some_command arg1 arg2) > afile.txt

Send value of a variable as standard input (stdin) to a command, and capture output in another variable:
::

    $ myvar="one two"
    $ yourvar=$(tr ' ' '_' <<<$myvar)
    $ echo $yourvar
    one_two

Send value of a variable as input to a chain of piped commands, and capture output in another variable:
::

    $ myvar=abcde
    $ yourvar=$(tr 'a' 'b' <<<$myvar | tr 'b' 'c' | tr 'c' 'd')
    $ echo $yourvar
    dddde

Truncate a file (wipe its contents):
::

    > myfile.txt


Booleans in bash
----------------

::

    hot=true

    if $hot; then
        echo "It's hot"
    else
        echo "It's cold"
    fi


Globbing in bash
----------------

Test if glob expands to anything:
::

    theGlob=*.html
    if stat -t $theGlob > /dev/null 2>&1; then
        echo *.html
    else
        echo No matches found.
    fi

or with "find":
::

    theGlob=*.html
    if [ -n "$(find . -maxdepth 1 -name "$theGlob" -print -quit)" ]; then
        echo *.html
    else
        echo No matches found.
    fi


Variable assignment in bash
---------------------------

Set the variable logDir to $LOG_DIR, or '~/log' if $LOG_DIR is an empty string:
::

  logDir=${LOG_DIR:-~/log}

Example:
::

    $ someVar=foo
    $ emptyVar=
    $ myVar=${someVar:-bar}
    $ yourVar=${emptyVar:-bar}
    $ echo myVar = $myVar; echo yourVar = $yourVar
  myVar = foo
  yourVar = bar

Set the variable myVar to 'foo' if $myVar is an empty string, otherwise leave myVar unchanged
::

  : ${myVar:=foo}

Example:
::

    $ myVar=foo
    $ yourVar=
    $ : ${myVar:=bar}
    $ : ${yourVar:=bar}
    $ echo myVar = $myVar; echo yourVar = $yourVar
  myVar = foo
  yourVar = bar

Equivalent of ternary operator in bash:
::

    [[ "$year" = "leapyear" ]] && numdays=366 || numdays=365


Keyboard shortcuts in bash:
---------------------------

Clear screen:
::

  ctrl-l

Open editor to write command in:
::

  Ctrlv-XE

Keyboard shortcuts (from: http://www.getoffmalawn.com/blog/useful-bash-shortcuts):
::

    Movement
    --------

    Shortcut        Action
    Ctrl-a          Move to the start of the line
    Ctrl-e          Move to the end of the line
    Ctrl-b          Move back one character
    Alt-b           Move back one word
    Ctrl-f          Move forward one character
    Alt-f           Move forward one word
    Ctrl-] x        Move the cursor forward to next occurance of x
    Alt-Ctrl-] x    Move the cursor backward to the next occurance of x


    Line Modification
    -----------------

    Shortcut        Action
    Ctrl-u          Delete from the cursor to the beginning of the line
    Ctrl-k          Delete from the cursor to the end of the line
    Esc Backspace   Delete back a word
    Alt-d           Delete forward a word
    Alt-r           Undo all changes to the line
    Ctrl-y          Paste any text deleted with previous shortcuts
    Ctrl-e Esc-t    Swap order of the last two arguments


    History Utilisation
    -------------------

    Shortcut        Action
    Ctrl-x Ctrl-u   Undo the last change to the line
    Ctrl-r          Incremental reverse search of history
    Alt-p           Non-incremental reverse search of history
    Ctrl-L          Clear the screen (doesn't wipe current line)
    !!              Execute last command in history
    !abc            Execute last command in history beginning with abc
    !n              Execute nth command in history
    !$              Last argument of previous command
    !^              First argument of previous command
    ^abc^xyz        Replace first occurance of abc with xyz in previous command and execute it
    Alt-. (period)  Paste last word from previous command after cursor position (repeat to cycle through previous commands)


Miscellaneous bash commands:
----------------------------

List commands found in bash history, sorted by usage:
::

  cat ~/.bash_history | cut -f1 -d' ' | sort | uniq -c | sort -n -r | more

ln
==

Create hard links in a folder to all files in another folder, eg:
::

    ln -t ~/.gnome2/nautilus-scripts ~/tools/nautilus/*

Create symbolic link named 'LNK' to target file named 'TGT':
::

    ln -s TGT LNK

Run command in background and return to shell immediately (e.g. 'firefox index.html').
Don't write any output to nohup.out.
::

    nohup firefox index.html > /dev/null 2>&1

tar
===

Create tar.gz from directory:
::

    tar cpzf mydir.tar.gz mydir

Extract directory from tar.gz file:
::

    tar xzf mydir.tar.gz


Check Linux version
===================
::

    cat /etc/issue

or

::

    lsb_release -a

or

::

    cat /etc/lsb-release

or

::

    uname -a

or

::

    cat /proc/version

Logfiles
========

Browse syslog with vim (requires https://github.com/bergoid/rabot):
::

    find /var/log -maxdepth 1 | grep syslog | sort | flon

Batch renaming
==============

Replace a substring 'foo' with 'bar' in all names of textfiles

Output every renaming command for review:
::

    for filename in *.txt ; do echo mv \"$filename\" \"${filename//foo/bar}\"; done

Execute the reviewed commands:
::

    for filename in *.txt ; do echo mv \"$filename\" \"${filename//foo/bar}\"; done | /bin/bash

ls, find, grep
==============

List all filenames in directory tree:
::

    find . -print

or:
::

    find .

or:
::

    find $(pwd)

List files in reverse chronological order:
::

    ls -lt

List the the most recently modified files in directory tree:
::

    find . -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | head

List files in reverse order by size:
::

    ls -lS


List only filenames:
::

    ls -m1


Find all files matching  '\*.c':
::

    find . -name \*.c

Find directories named 'mydir':
::

    find . -type d -name mydir


Search for 'pattern' in all .cpp files in 'mydir', recursively:
::

    grep pattern -nr --include=\*.cpp mydir


Search for 'pattern' in all .cpp and .h files in 'mydir', recursively:
::

    grep pattern -nr --include=\*.{cpp,h} mydir


Search for 'pattern' in all files in current dir, but don't recurse into subdirectories:
::

    grep -d skip pattern *


Replace all occurrences of 'oldstring' with 'newstring' in all .txt files in directory tree rooted in '.':

::

    find . -name '*.txt' -type f -print0 | xargs -0 sed -i 's|oldstring|newstring|g'


Remove all .flac files in directory tree rooted in '.':

::

    find . -name '*.flac' -type f -print0 | xargs -0 rm


Compare 2 directories: print 2 columns of files unique to either directory:

::

    comm -3 <(find dir1 -type f -printf '%f\n' | sort -u) <(find dir2 -type f -printf '%f\n' | sort -u)


directories
===========

cd into parent dir of currently running bash script:
::

    cd $(dirname $(readlink -f $0))



Lines in files
==============

Output Nth line of file
::

    more +N file | head -n 1

or

::

    head -N file | tail -1

Count the number of lines in file:
::

    wc -l < my_text.txt


Modify files
============

Remove all blank lines
::

    cat file.txt | sed '/^\s*$/d' > file2.txt

or in-place:
::

  sed -i '/^\s*$/d' file.txt


Package management
==================

dpkg
----

Show (among other info) dependencies of .deb file:
::

    dpkg -I package_file.deb

Install a .deb file:
::

    sudo dpkg -i package_file.deb

Uninstall a .deb file:
::

    sudo dpkg -r package_file.deb

List all installed packages:
::

    dpkg -l

List files provided by package:
::

    dpkg -L packagename

pacman
------

Install a package
::

    pacman -Syu package_name

Check if a package is installed:
::

    pacman -Q package_name

List all files owned by an installed package:
::

    pacman -Ql package_name

Find package that owns a given file
::

    pacman -Qo file_path

Display info about an installed package:
::

    pacman -Qi package_name

Display info about a package:
::

    pacman -Si package_name

Uninstall a package and its orphaned dependencies:
::

    pacman -Rs package_name

Clean pacman cache ( /var/cache/pacman/pkg ):
::

    pacman -Scc

List all packages from a given repository (here 'community' as an example):
::

    paclist community

Print dependency tree of a package:
::

    pactree packagename

OpenBox
=======

Edit the OpenBox menu:
::

    vi ~/.config/openbox/menu.xml

Edit the OpenBox settings:
::

    vi ~/.config/openbox/rc.xml

Go to location of .desktop files:
::

    cd /usr/share/applications

Reconfigure OpenBox:
::

    openbox --reconfigure

Make bootable USB stick from .iso file
======================================

From:
        http://crunchbang.org/forums/viewtopic.php?id=23267

Determine what device your USB is.  With your USB plugged in run:
::

        sudo ls -l /dev/disk/by-id/*usb*

This should produce output along the lines of:
::

        lrwxrwxrwx 1 root root  9 2010-03-15 22:54 /dev/disk/by-id/usb-_USB_DISK_2.0_077508380189-0:0 -> ../../sdb
        lrwxrwxrwx 1 root root 10 2010-03-15 22:54 /dev/disk/by-id/usb-_USB_DISK_2.0_077508380189-0:0-part1 -> ../../sdb1

Now cd to where your \*.iso is
::

        cd ~/downloads

Example
::

        sudo dd if=filename.iso of=/dev/usbdevice; sync

let's say the iso is named mini.iso and your USB device is sdb

Example
::

        sudo dd if=mini.iso of=/dev/sdb; sync

vim
===

Some shortcuts:
::

    Deleting text:
    dd      Delete line
    dw      Delete rest of word, until (but excluding) start of next word
    D       Delete rest of line (including character under cursor)
    d$      "
    d0      Delete beginning of line before cursor
    x       Delete character
    da(     delete a set of matching parens and everything in them
    S       substitute line (i.e. replace entire line with an empty line and go to insert mode)
    :%s/\s\+$//   delete trailing whitespace on all lines

    Inserting text:
    i               Insert text before cursor
    a               Insert text after cursor
    A               Append text to the end of a line
    I               Insert text before the first non-blank in the line
    C               Replace rest of line
    o               Insert new line above cursor
    O               Insert new line below cursor
    ctrl-v<tab>     Insert tab character even when expandtab is on

    :r !ls      Insert output of shell command into text (here: ls)

    Transforming text:
    ctrl-a    increment number under cursor
    ctrl-x    decrement number under cursor

    u       undo
    ctrl-r  redo

    Moving:
    g;      jump back to last edited position.
    g_      go to last non-whitespace character on line
    w       go to start of next word
    e       go to end of (next) word
    b       go start of (previous) word
    W       go to start of next word (words are whitespace-delimited)
    E       go to end of word (words are whitespace-delimited)
    B       go start of (previous) word (words are whitespace-delimited)
    zz  put current line at the center of the screen
    zz  move current line to the middle of the screen
    zt  move current line to the top of the screen
    zb   move current line to the bottom of the screen
    Ctrl-e  Moves screen up one line
    Ctrl-y  Moves screen down one line
    Ctrl-u  Moves screen up ½ page
    Ctrl-d  Moves screen down ½ page
    Ctrl-b  Moves screen up one page
    Ctrl-f  Moves screen down one page

    Selecting pieces of text:
    vw      select from cursor to start of next word
    vb      select from cursor to start of word under cursor
    vaw     select word under cursor
    vi(     select parens block, parens excluded
    va(     select parens block, parens included
    vi", vi', vi[, vi<, vi{     analogous as 2 lines higher
    va", va', va[, va<, va{     analogous as 2 lines higher
    vit     select text between HTML tags
    vat     select text between HTML tags, together with the tags themselves

    File handling:
    :e filename     Open new file in editor
    :e! filename    Open new file in editor, discard buffer
    :e .                    Browse current directory
    :w                      Write buffer
    :w filename     Write buffer to filename
    :q                      Exit vim
    ZZ                      Save buffer and exit vim
    :x                      "
    ZQ                      Discard buffer and exit vim
    :q!                     "

    Searching:
    /searchstring           search for searchstring
    /searchstring\c     case-insensitive search for searchstring

    :%s/old/new/g           replace all occurrences of 'old' with 'new'
    :%s/\<old\>/new/g   same, but whole word only
    :%s/old\c/new/g     replace all case-insensitive matches of 'old' with 'new'
    :%s/old/new/gc          replace all occurrences of 'old' with 'new', confirm each substitution
    :%s/\t/    /g       replace all tabs with 4 spaces

    Tabs:
    :set expandtab
    :set tabstop=4

    Comment all lines of a block
    Go to the first line, press ctrl-v, select until last line, press I#<Esc>

    Reselect block:
    gv

    Uncomment all lines of a block
    Go to the first line, press ctrl-v, select until last line, press x

    Multi-window:
    Ctrl-w o    Close all windows except current:
    :on        idem
    Ctrl-w q    Close current window
    Ctrl-w p    Switch to previously accessed window:

    Colors:
    Show highlight groups with their current color:
    :so $VIMRUNTIME/syntax/hitest.vim

scp
===

Copy the file "foobar.txt" from the local host to a remote host
::

    scp foobar.txt your_username@remotehost.edu:some/remote/directory

Copy the file "foobar.txt" from a remote host to the local host
::

    scp your_username@remotehost.edu:foobar.txt some/local/directory

Copy the directory "foo" from the local host to a remote host's directory "bar"
::

    scp -r foo your_username@remotehost.edu:some/remote/directory/bar

Copy the directory "foo" from a remote host to the local host's directory "bar"
::

    scp -r your_username@remotehost.edu:some/remote/directory/foo bar


apt-get and dpkg
================

Show info about file.deb:
::

    dpkg -I file.deb


echo text and redirect to privileged file:
==========================================
::

    echo 'some text' | sudo tee -a /etc/some.file


Start/stop/enable/disable daemons
=================================

Enable the ssh daemon:
::

    update-rc.d ssh defaults

Disable it:
::

    update-rc.d -f ssh remove

Start daemon:
::

    sudo service ssh start

Restart daemon:
::

    sudo service ssh restart

Stop daemon:
::

    sudo service ssh stop


List of options for 'setxkbmap':
================================
::

  vi /usr/share/X11/xkb/rules/base.lst



tmux
====

Create new session:
::

  $ tmux new -s session-name

Detach from session:
::

  <CTRL-b> d

Attach to first available session:
::

  $ tmux a

Attach to specific session:
::

  $ tmux a -t session-name


Install Oracle Java 7 in Debian Wheezy:
=======================================

From: http://stackoverflow.com/questions/15543603/installing-java-7-oracle-in-debian-via-apt-get

::

  sudo su

  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
  apt-get update
  apt-get install oracle-java7-installer


Git
===

Web project: use Github Pages for a live demo
---------------------------------------------

Source:

https://help.github.com/articles/creating-project-pages-manually/

http://lea.verou.me/2011/10/easily-keep-gh-pages-in-sync-with-master/

To create a Github Pages presence for your repo:

::

  git checkout --orphan gh-pages
  git merge master
  git push origin gh-pages
  git checkout master

The demo will be visible at username.github.io/reponame

To get the demo up-to-date with the master branch:

::

  git checkout gh-pages
  git merge master
  git push origin gh-pages
  git checkout master
