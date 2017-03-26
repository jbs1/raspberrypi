### Comment at the start

I made this mainly to be able to use Android SmartLock with my phone to keep my phone unlocked in my room and because I had a Pi1 and a really old bluetooth dongle lying around. I don't use it for playback as the Pi1's playback quality is way to bad, also due to CPU limitation.  
But since Android SmartLock requires and actual connection and just a known bluetooth device beeing around, I had to give it a service to connect to.  
I would assume with a more powerful Pi, eg. a Pi3 or something the playback would be good enough for using it. This guide should work on all module running the standard Raspbian Jessie.  



# Bluetooth playback through Raspberry Pi's audio jack

#### Install the prerequisites:
```
sudo apt-get install bluez pulseaudio pulseaudio-module-bluetooth python-gobject python-gobject-2
```

#### Enable Bluetooth as Audio sink/source:
Edit `/etc/bluetooth/audio.conf`:  
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
Edit `/etc/pulse/system.pa`:
```
.ifexists module-bluetooth-discover.so
load-module module-bluetooth-discover
.endif
```

#### Create autostarting pulseaudio service:
Create `/etc/systemd/system/pulseaudio.service`:
```
[Unit]
Description=Pulse Audio

[Service]
Type=simple
ExecStart=/usr/bin/pulseaudio --system --disallow-exit --disable-shm --exit-idle-time=-1

[Install]
WantedBy=multi-user.target
```
Enable the service for autostart:
```
sudo systemctl daemon-reload
sudo systemctl enable pulseaudio.service
```

#### Pairing the device:
For searching and paring use the bluetoothclient via `sudo bluetoothctl`.  
Prepare it for pairing with the following comands:
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

After the devices are paired/connected type `trust <MAC of phone>` in the console, so you don't have to put in the PIN for every connection. Then reboot the PI.

#### Setting up audio playback:
Make sure your phone is connected by either typing `connect <MAC of phone>` in the `bluetoothctl` console or by connecting via the phones bluetooth manager.  

To check whether `pulseaudio` recognizes your phone as an audio source type `sudo pactl list sources short` and check whether it appears in the list as `bluez_source.XX_XX_XX_XX_XX_XX` where the X's represent the Phones bluetooth MAC-adress. This will be your source for the loopback module.  

To enable playback on the audiojack find the right sink/output via `sudo pactl list sinks short`.  

Now with the sink and source from the commands above call the loopback module like this:
```
sudo pactl load-module module-loopback source=bluez_source.XX_XX_XX_XX_XX_XX sink=alsa_output.0.analog-stereo
```

Now connect a speaker to the output-jack and play something on your phone and it should play on the speakers connected to your PI.  


#### Automating connection and playback setup:
Currently you would have manually connect the phone and setup the loopback module every time we want to use it. This can be avoided with a simple cronjob.  

First download the [bluetooth.sh-script](https://github.com/jbs1/raspberrypi/blob/master/bluetooth.sh) from this repository or clone this repo on your raspberry pi. Edit the bluetooth MAC-address in the script such that it fit's your phone's MAC-address.

Then edit the crontab via `crontab -e` and add this with the correct path:
```
* * * * * <script/repo-path>/bluetooth.sh>/dev/null 2>&1
```
This will execute the script every minute, look for a device with the fitting MAC-address, connect to it and setup the loopback module.  

If you want want the crontab to not point directly at the cloned repository symbolic links come in handy.  To setup a symblic link do this:
```
ln -s <script/repo-path>/bluetooth.sh <target-path>/bluetooth.sh
```
This will basically create a file at `<target-path>` that always has the content of the script in `<script/repo-path>` because it is linked. Then edit the `crontab -e` like this:
```
* * * * * <target-path>/bluetooth.sh>/dev/null 2>&1
```

Credit to [source1](https://github.com/davidedg/NAS-mod-config/blob/master/bt-sound/bt-sound-Bluez5_PulseAudio5.txt) & [source2](https://www.raspberrypi.org/forums/viewtopic.php?t=68779)



## Further Information/Configuration


#### Editing the Pi's volume:
Edit the volume like this, where the `50%` are the desired Volume.
```
sudo amixer set Master 50%
```
With a Raspberry Pi 1 B if the Volume is set above 50% it will stop working and you will have to restart your Pi and set the Volume to something lower before you start playback again. I assume it is some kind of issue that it takes to much power or CPU. _Not tested with other models._


#### Changing the resample methode:
If the resample methode is changed to trivial pulseaudio supposedly uses less CPU at the expense of playback quality.  To change it in `/etc/pulse/daemon.conf` edit the `resample-methode` line to this:
```
resample-method = trivial
```
Make sure there is no `;` at the start of the line because that would disable this line and make it a comment.


#### Edit bluetooth adapter timings:
In `/etc/bluetooth/main.conf` you should probably remove the `#` in the following lines and edit the numbers such that the bluetooth adapter automatically goes hidden and unpairable again after you made it visible. For security.
```
DiscoverableTimeout = 60
PairableTimeout = 60
```
#### Further Info:
Here you can generate class hex's for the respective bluetooth-device-classes:  
[Generate Class Hex](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html)

