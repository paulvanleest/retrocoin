#!/bin/bash

# File to save the tag status
TAG_STATUS_FILE="/tmp/tag_status"

# Function to execute the command
execute_command() {
    echo "Tag gedetecteerd, start programma"

    export DISPLAY=:0

    # Commando uitvoeren
    nohup $1 &
    if [ $? -eq 0 ]; then
        echo "Programma succesvol gestart"
    else
        echo "Er is een fout opgetreden bij het starten van het programma"
    fi
}

# Read current tag and save it to the file
current_tag=$(/opt/nfc-read/nfc_read)
echo "$current_tag" > $TAG_STATUS_FILE

while true; do
    # Read the previous tag
    previous_tag=$(cat $TAG_STATUS_FILE)
    # Read the current tag
    current_tag=$(/opt/nfc-read/nfc_read)

    # Check if the tag is removed
    if [ "$current_tag" == "No NFC tag found." ]; then
        echo "Geen tag gedetecteerd"
        echo "No NFC tag found." > $TAG_STATUS_FILE

        # Kill the process if the tag is removed
        if [ "No NFC tag found." != "$previous_tag" ]; then
            binary_path=$(echo $previous_tag | awk '{print $1}')
            truncated_binary=$(basename $binary_path)
            echo "Tag verwijderd, stop programma $truncated_binary"
            # Find and kill all game related processes (including child processes)
            pids=$(pgrep mame)
            for pid in $pids; do
                sudo kill -9 $pid
            done
        fi
        sleep 3
        continue
    fi

    # Execute the command if the tag is detected
    if [ "No NFC tag found." == "$previous_tag" ] && [ "$current_tag" != "No NFC tag found." ]; then
        execute_command "$current_tag"
        # Update the tag status
        echo "$current_tag" > $TAG_STATUS_FILE
    fi
    sleep 3
done
