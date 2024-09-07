import nfc
import sys

def on_connect(tag):
    try:
        print("Tag detected!")
        print("Tag ID:", tag.identifier.hex())
        print("Tag data:", tag.ndef.message.pretty())
    except Exception as e:
        print("Error reading tag:", e)
    return True

try:
    clf = nfc.ContactlessFrontend('usb')
    clf.connect(rdwr={'on-connect': on_connect})
except Exception as e:
    print("Error connecting to NFC reader:", e)
finally:
    try:
        clf.close()
    except Exception as e:
        print("Error closing NFC reader:", e)
