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

#either initiate pair on the phone and put in the pincode on device and phone
yes #for confirming media connection

#or init pair in console via
pair <MAC of phone>
<pincode input on both devices>
connect <MAC of phone>

#in both cases after that
trust <MAC of phone>  

```
 
for security edit the timings in `/etc/bluetooth/main.conf`
 
```
DiscoverableTimeout = 60

PairableTimeout = 60
```

restart the pi  
your phone should not appear under `sudo pactl list sources short` and  
`sudo pactl list short | grep bluez`  


to enable playback on the jack find the sink/output via `pactl list sinks short` and the input should be the phone as written in `pactl list sources short`  

now do this with the appropiate values from above:
```
pactl load-module module-loopback source=bluez_source.XX_XX_XX_XX_XX_XX sink=alsa_output.0.analog-stereo
```

edit volume via: max.50
```
sudo amixer set Master 60%
```

possible edit `sudo nano /etc/pulse/daemon.conf`:(????) testing required trivial=less cpu  
```
resample-method = trivial
```

symbolic link
```
ln -s /home/pi/raspberrypi/bluetooth.sh /home/pi/bluetooth.sh
```


crontab -e
```
* * * * * /home/pi/raspberrypi/bluetooth.sh >/dev/null 2>&1
```
  

### other stuff

[generate class hex](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html)

