#!/bin/bash

# Python script aanroepen om de NFC-kaart uit te lezen
game=$(python3 - <<END
import nfc

def on_connect(tag):
    if tag.ndef:
        for record in tag.ndef.records:
            if record.type == "urn:nfc:wkt:T":  # Text record
                print(record.text)
                return record.text
    return ""

clf = nfc.ContactlessFrontend('usb')
clf.connect(rdwr={'on-connect': on_connect})
END
)

# Reset NFC reader (want die hangt na inlezen via python)
usb_modeswitch -R -v 072f -p 2200

# Controleer of de game-naam is opgehaald
if [ -z "$game" ]; then
  echo "Geen game-naam opgehaald"
  exit 1
fi

echo "Tag gedetecteerd, start programma"

export DISPLAY=:0

# Controleer of fbneo beschikbaar is
if ! command -v /opt/FBNeo/fbneo &> /dev/null
then
    echo "fbneo could not be found"
    exit 1
fi

# Commando uitvoeren
nohup /opt/FBNeo/fbneo -integerscale -fullscreen -joy "$game" &> /var/log/fbneo.log &
if [ $? -eq 0 ]; then
    echo "Programma '$game' succesvol gestart"
else
    echo "Er is een fout opgetreden bij het starten van het programma"
fi
