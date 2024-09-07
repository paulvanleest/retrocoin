import nfc

def on_connect(tag):
    print("Tag detected!")
    print("Tag ID:", tag.identifier.hex())
    print("Tag data:", tag.ndef.message.pretty())
    return True

clf = nfc.ContactlessFrontend('usb')
try:
    clf.connect(rdwr={'on-connect': on_connect})
finally:
    clf.close()
