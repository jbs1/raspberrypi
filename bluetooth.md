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
 
 
 

### other stuff

[generate class hex](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html)

