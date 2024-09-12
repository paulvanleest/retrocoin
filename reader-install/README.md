#### Setup support for USB PN532 NFC card reader (QinHeng Electronics CH340 serial converter)

1.  uninstall brltty
sudo apt remove brltty

2.  Install Dependencies: First, install the required packages:
sudo apt update
sudo apt install libusb-1.0-0-dev libpcsclite-dev pcscd libnfc-bin libnfc-dev

3. Configure libnfc: Create a configuration file for libnfc:
sudo nano /etc/nfc/libnfc.conf

4. Add the following content to the file:
# Allow device auto-detection (default: true)
device.connstring = "pn532_uart:/dev/ttyUSB0"

5. Set Up Udev Rules:
Create a New Udev Rule: Open a new file for the udev rule:
sudo nano /etc/udev/rules.d/42-pn53x.rules

6. Add the Following Content: Paste the following lines into the file:
# PN532-UART
ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666", GROUP="plugdev"

7. Reload Udev Rules: Reload the udev rules to apply the changes:
sudo udevadm control --reload-rules
sudo udevadm trigger

8. Restart Services: Restart the pcscd service to apply the changes:
sudo systemctl restart pcscd

9. Test the NFC Reader: Use the nfc-list command to check if the NFC reader is detected:
nfc-list


Maybe needed:
Download the source code: git clone -b ubuntu https://github.com/juliagoda/CH341SER.git
Goto the directory of the source code
Compile: make
Sign the module (needed in systems with secure boot enabled) : kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der ./ch34x.ko
Load module: make load




Commands run:
    7  sudo apt install libnfc-bin
    8  nfc-list
    9  sudo poweroff
   10  sudo tee -a /etc/modprobe.d/blacklist-libnfc.conf <<EOF
   11  blacklist nfc
   12  blacklist pn533_usb
   13  blacklist pn533
   14  EOF
   15  cat /etc/modprobe.d/blacklist-libnfc.conf
   16  sudo apt search libnfc
   17  sudo apt install libnfc-dev
   18  sudo apt install libnfc-pn53x-examples
   19  cat /etc/modprobe.d/blacklist-libnfc.conf
   20  sudo modprobe -rf pn533_usb
   21  cd CH341SER_LINUX/driver/
   22  sudo make
   23  sudo apt install build-essential
   24  sudo make
   25  ls -la
   26  sudo make load
   27  sudo apt install linux-headers-6.8.0-44-generic
   28  sudo apt update
   29  sudo apt upgrade
   30  sudo apt remove brltty
   31  cd ..
   32  ls -la
   33  cd ..
   34  rm -R CH341SER_LINUX/
   35  ls -la
   36  git clone -b ubuntu https://github.com/juliagoda/CH341SER.git
   37  sudo apt install git
   38  git clone -b ubuntu https://github.com/juliagoda/CH341SER.git
   39  cd CH341SER/
   40  ls -la
   41  make
   42  kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der ./ch34x.ko
   43  clear
   44  kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der ./ch34x.ko
   45  ls -la
   46  cat readme.txt
   47  cat README.md
   48  clear
   49  make load
   50  sudo make load
   51  nfc-list
   52  sudo reboot
   53  nfc-list
   54  lsmod | grep -i ch34
   55  lsusb
   56  git clone https://github.com/juliagoda/CH341SER
   57  cd CH341SER/
   58  ls -la
   59  sudo make clean
   60  cp /sys/kernel/btf/vmlinux /usr/lib/modules/`uname -r`/build/
   61  sudo cp /sys/kernel/btf/vmlinux /usr/lib/modules/`uname -r`/build/
   62  sudo make
   63  sudo apt install dwarves
   64  sudo apt install pve-headers-5.11.22-1-pve/now build-essential dkms
   65  cp /sys/kernel/btf/vmlinux /usr/lib/modules/`uname -r`/build/
   66  sudo cp /sys/kernel/btf/vmlinux /usr/lib/modules/`uname -r`/build/
   67  make
   68  sudo make
   69  sudo make install
   70  sudo make load
   71  lsmod | grep ch34*
   72  sudo dmesg
   73  lsmod | grep ch34*
   74  sudo rmmod ch34x
   75  lsmod | grep ch34*
   76  ls /dev/tty*
   77  sudo usermod -a -G dialout $(whoami)
   78  sudo chmod a+rw /dev/ttyUSB0
   79  sudo dmesg
   80  clear
   81  nfc-list
   82  gototags
   83  sudo systemctl enable pcscd
   84  sudo systemctl enable pcscd.socket
   85  sudo systemctl start pcscd
   86  sudo systemctl status pcscd
   87  gototags
   88  sudo gototags
   89  gototags
   90  sudo apt search python
   91  sudo apt install python3
   92  sudo apt autoremove
   93  python3 4.py
   94  sudo apt install python3 python3-pip
   95  pip3 install nfcpy
   96  sudo pip3 install nfcpy
   97  sudo apt install python3-nfcpy
   98  pip install nfcpy --break-system-packages
   99  python3 4.py
  100  clear
  101  python3 4.py
  102  nfc-list
  103  lsusb
  104  dmesg
  105  sudo dmesg
  106  ls /dev/ttyUSB0
  107  sudo tail -f /var/log/syslog
  108  sudo reboot
  109  sudo tail -f /var/log/syslog
  110  cat /etc/modprobe.d/blacklist-libnfc.conf
  111  sudo rm /etc/modprobe.d/blacklist-libnfc.conf
  112  sudo modprobe -rf pn533_usb
  113  sudo tail -f /var/log/syslog
  114  sudo apt-get update
  115  sudo apt-get install libusb-1.0-0-dev libpcsclite-dev pcscd
  116  sudo apt-get install libnfc-bin libnfc-dev
  117  sudo nano /etc/nfc/libnfc.conf
  118  sudo cp /usr/share/doc/libnfc/examples/udev/42-pn53x.rules /etc/udev/rules.d/
  119  sudo udevadm control --reload-rules
  120  sudo nano /etc/udev/rules.d/42-pn53x.rules
  121  sudo udevadm control --reload-rules
  122  sudo udevadm trigger
  123  sudo systemctl restart pcscd
  124  nfc-list
  