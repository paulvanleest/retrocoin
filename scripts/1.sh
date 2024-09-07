#!/bin/bash

# Functie om NDEF waarde uit te lezen en te controleren of de tag leeg is
lees_ndef_waarde() {
    NDEF_WAARDE=$(python3 <<EOF
import nfc
import ndef

def lees_ndef():
    clf = nfc.ContactlessFrontend('usb')
    tag = clf.connect(rdwr={'on-connect': lambda tag: False})
    if tag.ndef:
        return ' '.join(str(record) for record in tag.ndef.records)
    clf.close()
    return ''

print(lees_ndef())
EOF
)

    if [ -z "$NDEF_WAARDE" ]; then
        echo "De NFC-tag is leeg."
    else
        echo "De waarde van de NFC-tag is: $NDEF_WAARDE"
    fi
}

# Aanroepen van de functie
lees_ndef_waarde
