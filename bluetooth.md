# Bluetooth and pulseaudio config

[pulseaudio](https://github.com/davidedg/NAS-mod-config/blob/master/bt-sound/bt-sound-Bluez5_PulseAudio5.txt)  
[bluetooth](https://www.raspberrypi.org/forums/viewtopic.php?t=68779)  

#### Install the prerequisites:
```
sudo apt-get install bluez pulseaudio pulseaudio-module-bluetooth python-gobject python-gobject-2
```

#### Enable Bluetooth as Audio sink/source:
edit `/etc/bluetooth/audio.conf`:  
```
[General]
Enable=Source,Sink,Media,Socket
```

#### Enable pulseaudio access for appropriate users:
```
sudo adduser pi pulse-access
sudo adduser root pulse-access
```

#### Enable pulseaudio bluetooth discovery in System mode:
edit `/etc/pulse/system.pa`:
```
.ifexists module-bluetooth-discover.so
load-module module-bluetooth-discover
.endif
```

#### Create autostarting pulseaudio service:
create `/etc/systemd/system/pulseaudio.service`:
```
[Unit]
Description=Pulse Audio

[Service]
Type=simple
ExecStart=/usr/bin/pulseaudio --system --disallow-exit --disable-shm --exit-idle-time=-1

[Install]
WantedBy=multi-user.target
```
enable the service for autostart:
```
sudo systemctl daemon-reload
sudo systemctl enable pulseaudio.service
```

#### Pairing the device:
for searching and paring use the bluetoothclient via `sudo bluetoothctl`  
prepare it for pairing with the following comands:
```
power on
discoverable on
pairable on
agent-on
default-agent
```
Then you can either initiate pairing via the phone or via the console.  
Via console:  
* `pair <MAC of phone>`
* type in the same PIN on the phone and on the console when asked
* `connect <MAC of phone>`

Via phone:
* search for the raspberry pi on the phone and initiate pair
* type in the same PIN on the phone and on the console when asked
* when asked for media connection confirmation on the console type `yes`

After the devices are paired/connected type `trust <MAC of phone>` in the console, so you don't have to put in the PIN for every connection
 
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
* * * * * /home/pi/bluetooth.sh >/dev/null 2>&1
```
  

### other stuff

[generate class hex](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html)

