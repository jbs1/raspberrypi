# raspberrypi
A repo to keep all my RaspberryPi that does not need a dedicated repo.  

* bluetooth.\*: playback of bluetooth connected phone through audio jack (Android Smart Lock)
* shutdown.sh: reboot script for cronjob
  * added this to `crontab -e`: `30 04 * * * /home/pi/shutdown.sh`  
  and added a symlink from repo to `/home/pi/` for the script

