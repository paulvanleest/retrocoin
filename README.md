# ![LOGO](RetroCoinLogo.png)

Use NFC-tags as "real coins" to start arcade games in a self-made tabletop.

- [RETROCOIN](#retrocoin)
  - [SOFTWARE](#software)
    - [Install Ubuntu](#install-ubuntu)
    - [Make sure your NFC reader works](#make-sure-your-nfc-reader-works)
    - [install and configure fbneo (in /opt)](#install-and-configure-fbneo-in-opt)
    - [install nfc\_read](#install-nfc_read)
    - [install and enable the script and daemon-service](#install-and-enable-the-script-and-daemon-service)
    - [Prepare the coins](#prepare-the-coins)
    - [Fix the sound](#fix-the-sound)
    - [Make it your own (or not)](#make-it-your-own-or-not)
  - [HARDWARE](#hardware)

Please let me know if you use any of my code or what project you are starting. It's always nice to hear when this is usefull for anyone else.

## SOFTWARE

### Install Ubuntu

   Lots of guides to do this, not part of this readme.
   Another distro can be used, but that is not part of this readme. Figure it out/create a fork/whatever.

### Make sure your NFC reader works

   This can be a whole chapter on its own.
   See reader-install/README.md for (unfinished) documentation

### install and configure fbneo (in /opt)

   FBNeo requires libsdl2-2.0-0, libsdl2-dev, libsdl2-image-2.0-0, libsdl2-image-dev, build-essential, perl and nasm, so go to a terminal nd enter:

   ```bash
   sudo apt install libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev build-essential perl nasm
   ```

   Clone the repo and run make sdl2:

   ```bash
   git clone git@github.com:finalburnneo/FBNeo.git
   cd FBNeo
   make sdl2
   ```

   After creation, I choose to run it from the desktop to see if it starts
   go to ~/.local/share/fbneo/config/fbneo.ini and add the roms folder
   Optional: copy hiscore.dat to ~/.local/share/fbneo/support/hiscores
   Do additional actions as you wish like adding cheats in ~/.local/share/fbneo/support/cheats
   Then start from desktop again and setting it up from there, run a rom scan and testing a game
   Then test is if works by starting a game from the command line

### install nfc_read

   copy binary nfc_read to /opt/nfc-read (or compile a new one from nfc_read.c) 

### install and enable the script and daemon-service

   ```bash
   sudo cp scripts/nfc_start.sh /opt/
   sudo cp daemon-service/nfc_start.service /etc/systemd/system/
   sudo systemctl enable nfc_start.service
   sudo systemctl start nfc_start.service
   ```

### Prepare the coins

   Write the tags using any tag writer or your phone to create a NDEF text record in the tag.
   The tag must contain the full command, example:

   ```bash
    /opt/FBNeo/fbneo -integerscale -fullscreen -joy ddragon3
   ```

### Fix the sound

   If there is sound, but no display: Sometimes, you need to allow access to the X server. You can do this by running:

   ```bash
   xhost +local:
   ```

   This is a temporary fix, after reboot this command is needed again. Permanent fix is to add it to autostart:

   ```bash
   mkdir ~/.config/autostart
   sudo nano ~/.config/autostart/xhost.desktop
   ```

   insert code:

   ```bash
       [Desktop Entry]
       Type=Application
       Exec=xhost +local:
       Hidden=false
       NoDisplay=false
       X-GNOME-Autostart-enabled=true
       Name[en_US]=xhost
       Name=xhost
       Comment[en_US]=Allow local connections
       Comment=Allow local connections
   ```

### Make it your own (or not)

   Setup an arcade background
   Hide all bars and buttons
   Autostart without login
   Keepalive without locking
   Other fun enhancements like switching backgrounds or play arcade demo/intro shorts
   I have now only configured fbneo, but any program can be installed and run with the coins. So if some games require mame, go ahead and install it and write your tag/coin accordingly.

## HARDWARE

What I use:

- Self-made tabletop from MDF
- Old monitor
- Intel NUC equivalent (mounted on back of monitor)
- Ultimarc I-PAC 2
- 2 joys and multiple buttons
- Seperate on/off switch (soldered into NUC)
- PN532 NFC reader/writer
- coin tags and holders
- currently in the process of making a "coincollector"
