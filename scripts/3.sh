#!/bin/bash

# Python code in een variabele
python_code=$(cat <<EOF
def echo_input():
    # Vraag de gebruiker om een invoer
    user_input = input("Voer iets in: ")
    
    # Toon de invoer als echo op het scherm
    print("Echo:", user_input)

if __name__ == "__main__":
    echo_input()
EOF
)

# Schrijf de Python code naar een tijdelijk bestand
echo "$python_code" > temp_echo_script.py

# Voer het tijdelijke Python-script uit
python3 temp_echo_script.py

# Verwijder het tijdelijke Python-script
rm temp_echo_script.py
