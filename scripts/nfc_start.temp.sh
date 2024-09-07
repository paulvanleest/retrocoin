#!/bin/bash

# Script om het commando elke 3 minuten uit te voeren op display 0
while true; do
    DISPLAY=:0 nohup /opt/FBNeo/fbneo -integerscale -fullscreen -joy alexkidd &
    sleep 180  # 180 seconden is gelijk aan 3 minuten
done
