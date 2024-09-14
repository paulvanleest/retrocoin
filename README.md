# retrocoin
Use NFC-tags as "real coins" to start arcade games in a tabletop


1.  install ubuntu
    Lots of guides to do this, not part of this readme
    Make it your own (like add a nice arcade background, hide all bars and buttons et cetera)
    Autostart without login, keepalive without locking
    Other fun enhancements like switching backgrounds or play arcade demo/intro shorts

    Note: Another distro can be used, but that is not part of this readme. Figure it out/create a fork/whatever

2.  Make sure your NFC reader works (this can be a whole chapter on it s own), see reader-install/README.md for (unfinished) documentation

3.  install and configure fbneo (in /opt)
    FBNeo requires libsdl2-2.0-0, libsdl2-dev, libsdl2-image-2.0-0, libsdl2-image-dev, build-essential, perl and nasm, so go to a terminal and enter:
    sudo apt install libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev build-essential perl nasm
    Clone the repo and run make sdl2:
    git clone git@github.com:finalburnneo/FBNeo.git
    cd FBNeo
    make sdl2
    After creation, I choose to run it from the desktop to see if it starts
    go to ~/.local/share/fbneo/config/fbneo.ini and add the roms folder
    Optional: copy hiscore.dat to ~/.local/share/fbneo/support/hiscores
    Do additional actionsas you wish like adding cheats in ~/.local/share/fbneo/support/cheats
    Then start from desktop again and setting it up from there, run a rom scan and testing a game
    Then test is if works by starting a game from the command line

4.  install nfc_read
    copy binary nfc_read to /opt/nfc-read (or compile a new one from nfc_read.c) 

5.  install and enable the service
    sudo cp nfc_start.service /etc/systemd/system/
    sudo systemctl enable nfc_start.service
    sudo systemctl start nfc_start.service

6.  If there is sound, but no display: Sometimes, you need to allow access to the X server. You can do this by running:
    xhost +local:
    this appears a temporary fix, after reboot this command is needed again. Permanent fix: ..........