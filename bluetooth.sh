#!/bin/bash
echo -e 'power on\nconnect A4:E4:B8:AB:4E:36\nquit' | bluetoothctl
sleep 5
sudo pactl load-module module-loopback source=bluez_source.A4_E4_B8_AB_4E_36 sink=alsa_output.0.analog-stereo
