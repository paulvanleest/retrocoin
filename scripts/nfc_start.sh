#!/bin/bash

# Bestand om de status van de tag op te slaan
TAG_STATUS_FILE="/tmp/tag_status"

# Functie om het commando uit te voeren
execute_command() {
    echo "Tag gedetecteerd, start programma"

    export DISPLAY=:0

    # Commando uitvoeren
    nohup "$1" &
    if [ $? -eq 0 ]; then
        echo "Programma succesvol gestart"
    else
        echo "Er is een fout opgetreden bij het starten van het programma"
    fi
}

# Lees de huidige tag en initialiseer de tag status file
current_tag=$(/opt/nfc-read/nfc_read)
echo "$current_tag" > $TAG_STATUS_FILE

while true; do
    # Controleer of er een tag aanwezig is
    if [ "$(/opt/nfc-read/nfc_read)" == "No NFC tag found." ]; then
        echo "Geen tag gedetecteerd"
        echo "No NFC tag found." > $TAG_STATUS_FILE
        # sleep 3
        continue
    fi

    # Lees de huidige tag
    current_tag=$(/opt/nfc-read/nfc_read)
    # Lees de vorige tag status
    previous_tag=$(cat $TAG_STATUS_FILE)


    # Voer het commando uit als een tag wordt geplaatst
    if [ "No NFC tag found." == "$previous_tag" ] && [ "$current_tag" != "No NFC tag found." ]; then
        execute_command "$current_tag"
        # Update de tag status
        echo "$current_tag" > $TAG_STATUS_FILE
    fi

    # Wacht even voordat je opnieuw leest
    sleep 3
done
