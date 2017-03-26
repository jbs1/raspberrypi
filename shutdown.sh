#!/bin/bash
wall "Reboot in 5 seconds!"
date  +"%H:%M:%S %d.%m.%Y" >/home/pi/last_shutdown
sleep 5
sudo reboot
