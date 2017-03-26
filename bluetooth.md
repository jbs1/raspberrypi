# Bluetooth and pulseaudio config

[pulseaudio](https://github.com/davidedg/NAS-mod-config/blob/master/bt-sound/bt-sound-Bluez5_PulseAudio5.txt)  
[bluetooth](https://www.raspberrypi.org/forums/viewtopic.php?t=68779)  

 `sudo apt-get --purge --reinstall install pulseaudio`
 
 ```
 sudo apt-get install bluez pulseaudio python-gobject python-gobject-2 pulseaudio-module-bluetooth
 ```
 
 add to `sudo nano /etc/bluetooth/audio.conf`
 ```
 [General]
 Enable=Source,Sink,Media,Socket
 ```
 
 ```
 sudo adduser pi pulse-access
 sudo adduser root pulse-access
 ```
 
 
 ```
 # Load  Bluetooth discover module in SYSTEM MODE:
############################################################################
cat <<EOF >> /etc/pulse/system.pa
#
### Bluetooth Support
.ifexists module-bluetooth-discover.so
load-module module-bluetooth-discover
.endif
EOF
############################################################################



# Create a systemd service for running pulseaudio in System Mode as user "pulse".
############################################################################
cat <<EOF >/etc/systemd/system/pulseaudio.service
[Unit]
Description=Pulse Audio

[Service]
Type=simple
ExecStart=/usr/bin/pulseaudio --system --disallow-exit --disable-shm --exit-idle-time=-1

[Install]
WantedBy=multi-user.target
EOF


###############################################################

systemctl daemon-reload
systemctl enable pulseaudio.service
```
 
search and pair device via
 
```
sudo bluetoothctl
power on
discoverable on
pairable on
agent-on
default-agent

#then initiate pair on phone and put in the pin
yes #for connecting to services

trust <MAC of phone>  

```
 
 
 

### other stuff

[generate class hex](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html)

