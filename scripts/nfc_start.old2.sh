#!/bin/bash

# Omleiden van alle uitvoer naar een logbestand
exec > /tmp/nfcstart.log 2>&1

# Bestand om de status van de tag op te slaan
TAG_STATUS_FILE="/tmp/tag_status"

# Functie om de NFC-tag te lezen
read_nfc_tag() {
    python3 - <<END
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
}

# Functie om het commando uit te voeren
execute_command() {
    echo "Tag gedetecteerd, start programma"

    export DISPLAY=:0

    # Controleer of fbneo beschikbaar is
    if ! command -v /opt/FBNeo/fbneo &> /dev/null
    then
        echo "fbneo could not be found"
        exit 1
    fi

    # Commando uitvoeren
    nohup /opt/FBNeo/fbneo -integerscale -fullscreen -joy "$1" &> /var/log/fbneo.log &
    if [ $? -eq 0 ]; then
        echo "Programma succesvol gestart"
    else
        echo "Er is een fout opgetreden bij het starten van het programma"
    fi
}

# Initialiseer de status van de tag
echo "none" > $TAG_STATUS_FILE

while true; do
    # Lees de huidige tag
    current_tag=$(read_nfc_tag)

    # Reset NFC reader (want die hangt na inlezen via python)
    usb_modeswitch -R -v 072f -p 2200

    # Controleer of de game-naam is opgehaald
    if [ -z "$current_tag" ]; then
        echo "De tag is leeg"
        sleep 1
        continue
    fi

    # Lees de vorige tag status
    previous_tag=$(cat $TAG_STATUS_FILE)

    if [ "$current_tag" != "$previous_tag" ]; then
        # Voer het commando uit als de tag nieuw is
        execute_command "$current_tag"
        # Update de tag status
        echo "$current_tag" > $TAG_STATUS_FILE
    fi

    if [ "$current_tag" == "$previous_tag" ]; then
        # Dezelfde munt zit er nog in
        echo "$current_tag" > $TAG_STATUS_FILE
	echo "Dezelfde munt zit er nog in!"
    fi



    # Wacht even voordat je opnieuw leest
    sleep 1
done
