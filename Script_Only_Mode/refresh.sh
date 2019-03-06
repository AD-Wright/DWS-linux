#!/bin/bash

#filename: refresh.sh
###############################################################################
#                                                                             #
#    DWS-linux: desktop status for defconwarningsystem.com for linux users    #
#    Coded by A.D. Wright - GPLv3 License - github.com/AD-Wright/DWS-linux    #
#                                                                             #
###############################################################################

#installed directory (update after installation)
INSTALL_DIR=~/Documents/DWS-linux/Script_Only_Mode

#check current status icon color
DEFCON_COLOR=$(convert defcon.jpg -crop '1x1+45+95' txt:- | tail -c 9)

#start pipe for yad listening on exec 3
PIPE=$(mktemp -u --tmpdir ${0##*/}.XXXXXXXX)
mkfifo $PIPE
exec 3<> $PIPE

#make sure yad isn't already running
pkill yad

#start yad with "no connection" icon
yad --notification --kill-parent --listen <&3 &
echo "icon:$INSTALL_DIR/images/nc.png" >&3
echo "visible:blink" >&3
echo "tooltip:DWS_Notifier" >&3
echo "menu:Website!chromium-browser \
http://defconwarningsystem.com|Refresh!./refresh.sh|Quit!quit" >&3

#update with correct, current icon


#while loop (repeat every few minutes)
while true; do

#check current status:
# get a copy of the currently downloaded image
FILE='defcon.jpg'
CURRENT_TS=`stat -c %y $FILE`

# run wget to see if image timestamp has changed
wget --no-netrc \
 --no-http-keep-alive \
 --no-cookies \
 --user-agent="DWS-linux_test" \
 --timestamping "https://defconwarningsystem.com/current/defcon.jpg"

# check if wget downloaded an updated image
NEW_TS=`stat -c %y $FILE`
if [ "$CURRENT_TS" != "$NEW_TS" ]; then
    # read pixel from image, then update defcon index


    # update yad with correct icon




fi

#delay time between automatic refreshes, in seconds
sleep 300

#end loop
done
