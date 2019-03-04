#!/bin/bash

#installed directory (update after installation)
INSTALL_DIR=~/Documents/DWS-linux/Script_Only_Mode

# start YAD with NC icon, listening on exec 3
PIPE=$(mktemp -u --tmpdir ${0##*/}.XXXXXXXX)
mkfifo $PIPE
exec 3<> $PIPE
yad --notification --kill-parent --listen <&3 &
echo "icon:$INSTALL_DIR/images/nc_64.png" >&3
echo "menu:MENU" >&3

#use cron to run every few minutes? (would need two scripts, one on startup and one to update?)


#check if file has changed "wget"


#if has changed, run alert("notify-send"?), then find major color of image using "convert" from imageMajic


#use "yan" to manage GTK icon in systray and menu, maybe also alerts?


