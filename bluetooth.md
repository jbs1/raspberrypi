# Bluetooth stuff

### auto power on the dongle:  
`/etc/bluetooth/main.conf`

```
[Policy]
AutoEnable=true
```


### audio connection

In order to be able to use audio equipment like bluetooth headphones, you need to install the additional `pulseaudio-bluetooth` package.  
In order to enable your system to be detected as an A2DP sink (e.g. to play music from your phone via your computer speakers), edit:  
`/etc/bluetooth/audio.conf`

```
[General]
Enable=Source,Sink,Media,Socket
```



### stuff to be installed
```
bluez-tools
pulseaudio-module-bluetooth
```



### other stuff

[generate class hex](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html)





# CONFIGURE PULSEAUDIO


```
# Not strictly required, but you may need:
# In /etc/pulse/daemon.conf  change "resample-method" to either:
# trivial: lowest cpu, low quality
# src-sinc-fastest: more cpu, good resampling
# speex-fixed-N: N from 1 to 7, lower to higher CPU/quality
resample-method = trivial


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
############################################################################

systemctl daemon-reload
systemctl enable pulseaudio.service
```

