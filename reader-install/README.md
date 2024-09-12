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