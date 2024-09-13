#!/bin/bash

# Bestand om de status van de tag op te slaan
TAG_STATUS_FILE="/tmp/tag_status"

# Functie om de NFC-tag te lezen
# read_nfc_tag() {
#     python3 - <<END
# import nfc
# import ndef

# print("Python script gestart")

# def on_connect(tag):
#     print("Tag connected")
#     if tag.ndef:
#         print("NDEF records found")
#         for record in tag.ndef.records:
#             if isinstance(record, ndef.TextRecord):
#                 print(f"Record text: {record.text}")
#                 return record.text
#     print("No NDEF records found or not a text record")
#     return ""

# try:
#     clf = nfc.ContactlessFrontend('usb')
#     if not clf:
#         print("Failed to open NFC frontend")
#     else:
#         print("NFC frontend opened successfully")
#         clf.connect(rdwr={'on-connect': on_connect})
# except Exception as e:
#     print(f"Exception occurred: {e}")
# END
# }


# Functie om te controleren of er een tag aanwezig is
# is_tag_present() {
#     nfc-list | grep -q "NFC device"
#     return $?
# }

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
current_tag=$(../read-ndef/nfc_read)
echo "$current_tag" > $TAG_STATUS_FILE

while true; do
    # Controleer of er een tag aanwezig is
    if [$(../read-ndef/nfc_read) -eq "No NFC tag found."]; then
        echo "Geen tag gedetecteerd"
        echo "No NFC tag found." > $TAG_STATUS_FILE
        sleep 4
        continue
    fi

    # Lees de huidige tag
    current_tag=$(../read-ndef/nfc_read)

    # # Reset NFC reader (want die hangt na inlezen via python)
    # usb_modeswitch -R -v 072f -p 2200

    # Controleer of de game-naam is opgehaald
    if [ -z "$current_tag" ]; then
        echo "De tag is leeg"
        sleep 4
        continue
    fi

    # Lees de vorige tag status
    previous_tag=$(cat $TAG_STATUS_FILE)

    # Voer het commando uit als de tag nieuw is of als de tag opnieuw is geplaatst
    if [ "No NFC tag found." == "$previous_tag" ] && [ "$current_tag" != "No NFC tag found." ]; then
        execute_command "$current_tag"
        # Update de tag status
        echo "$current_tag" > $TAG_STATUS_FILE
    fi

    # Wacht even voordat je opnieuw leest
    sleep 4
done
