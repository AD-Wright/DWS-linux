#!/bin/bash

#called to update status icon for DWS-linux
pkill yad

#installed directory (update after installation)
INSTALL_DIR=~/Documents/DWS-linux/Script_Only_Mode

# start YAD with NC icon, listening on exec 3
PIPE=$(mktemp -u --tmpdir ${0##*/}.XXXXXXXX)
mkfifo $PIPE
exec 3<> $PIPE
yad --notification --kill-parent --listen <&3 &
echo "icon:$INSTALL_DIR/images/nc_16.png" >&3
echo "visible:blink" >&3
echo "tooltip:DWS_Notifier" >&3
echo "menu:Website!chromium-browser http://defconwarningsystem.com|Refresh!./refresh.sh|Quit!quit" >&3
