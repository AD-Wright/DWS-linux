#!/bin/bash

#filename: refresh.sh
###############################################################################
#                                                                             #
#    DWS-linux: desktop status for defconwarningsystem.com for linux users    #
#    Coded by A.D. Wright - GPLv3 License - github.com/AD-Wright/DWS-linux    #
#                                                                             #
###############################################################################

#make sure yad isn't already running
pkill yad

#installed directory (update after installation)
INSTALL_DIR=~/Documents/DWS-linux/Script_Only_Mode

#check current status
convert defcon.jpg -crop '1x1+45+95' txt:- | tail -c 9

#start pipe for yad listening on exec 3
PIPE=$(mktemp -u --tmpdir ${0##*/}.XXXXXXXX)
mkfifo $PIPE
exec 3<> $PIPE

#start yad with correct icon


yad --notification --kill-parent --listen <&3 &
echo "icon:$INSTALL_DIR/images/nc_16.png" >&3
echo "visible:blink" >&3
echo "tooltip:DWS_Notifier" >&3
echo "menu:Website!chromium-browser \
http://defconwarningsystem.com|Refresh!./refresh.sh|Quit!quit" >&3

#while loop (repeat every few minutes)
while true; do

#check current status:
# Get a copy of the current image
FILE='defcon.jpg'
CURRENT_TS=`stat -c %y $FILE`

# run wget to see if image has been updated
wget --no-netrc \
 --no-http-keep-alive \
 --no-cookies \
 --user-agent="DWS-linux_test" \
 --timestamping "https://defconwarningsystem.com/current/defcon.jpg"

# check if file was updated
NEW_TS=`stat -c %y $FILE`
if [ "$CURRENT_TS" != "$NEW_TS" ]; then
    # kill current process
    pkill yad

    # read pixel from image, then update defcon index


    # restart yad with correct icon
fi

#delay time between automatic refreshes, in seconds
sleep 300

#end loop
done



#reference code
# download image using wget
#wget --no-netrc --no-http-keep-alive --no-cookies --user-agent="DWS-linux_test" --timestamping "https://defconwarningsystem.com/current/defcon.jpg"


