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
DEFCON_COLOR=$(convert $INSTALL_DIR/defcon.jpg -crop '1x1+45+95'  \
txt:- | grep -oP 'b\([^\)]+' | tail -c +3)

#split current color into components by comma
RED=$(echo $DEFCON_COLOR | cut -d "," -f 1)
GREEN=$(echo $DEFCON_COLOR | cut -d "," -f 2)
BLUE=$(echo $DEFCON_COLOR | cut -d "," -f 3)

echo $RED.$GREEN.$BLUE

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

#update with last downloaded icon
if [ $BLUE == 92 ]; then
    echo "icon:$INSTALL_DIR/images/5.png" >&3

elif [ $BLUE == 254 ]; then
    echo "icon:$INSTALL_DIR/images/4.png" >&3

else
    echo "icon:$INSTALL_DIR/images/nc.png" >&3
fi
#finish with 3,2,1


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
    DEFCON_COLOR=$(convert $INSTALL_DIR/defcon.jpg -crop '1x1+45+95'  \
    txt:- | grep -oP 'b\([^\)]+' | tail -c +3)
    RED=$(echo $DEFCON_COLOR | cut -d "," -f 1)
    GREEN=$(echo $DEFCON_COLOR | cut -d "," -f 2)
    BLUE=$(echo $DEFCON_COLOR | cut -d "," -f 3)

    # update yad with correct icon
    if [ $BLUE == 92 ]; then
        echo "icon:$INSTALL_DIR/images/5.png" >&3

    elif [ $BLUE == 254 ]; then
        echo "icon:$INSTALL_DIR/images/4.png" >&3

    else
        echo "icon:$INSTALL_DIR/images/nc.png" >&3
    fi
    #finish with 3,2,1


fi

#delay time between automatic refreshes, in seconds
sleep 300

#end loop
done
