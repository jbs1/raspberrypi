# Bluetooth stuff

auto power on the dongle:  
`/etc/bluetooth/main.conf`

```
[Policy]
AutoEnable=true
```


### audio connection

In order to be able to use audio equipment like bluetooth headphones, you need to install the additional `pulseaudio-bluetooth` package.  
In order to enable your system to be detected as an A2DP sink (e.g. to play music from your phone via your computer speakers), add `Enable=Source,Sink,Media,Socket` under `[General]` in `/etc/bluetooth/audio.conf`.
