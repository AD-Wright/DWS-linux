#!/bin/bash

# filename: DWS-linux.sh
###############################################################################
#                                                                             #
#    DWS-linux: desktop status for defconwarningsystem.com for linux users    #
#    Coded by A.D. Wright - GPLv3 License - github.com/AD-Wright/DWS-linux    #
#                                                                             #
###############################################################################

### USER CONFIGURATION ###
# installed directory (update after installation)
INSTALL_DIR=~/Documents/DWS-linux

# update interval: default 300 (5 minutes), please don't use a shorter interval
UPDATE_INT=300

# notify if defcon level changes? (0 = no, 1 = yes)
NOTIFY=1

### END USER CONFIGURATION ###

# check current status icon color
DEFCON_COLOR=$(convert $INSTALL_DIR/defcon.jpg -crop '1x1+45+95'  \
txt:- | grep -oP 'b\([^\)]+' | tail -c +3)

# split current color into components by comma
RED=$(echo $DEFCON_COLOR | cut -d "," -f 1)
GREEN=$(echo $DEFCON_COLOR | cut -d "," -f 2)
BLUE=$(echo $DEFCON_COLOR | cut -d "," -f 3)

# for ease of determining values for 5,4,3,2,1 (DEBUG)
#echo $RED.$GREEN.$BLUE

# start pipe for yad listening on exec 3 (this is how we change the icon)
PIPE=$(mktemp -u --tmpdir ${0##*/}.XXXXXXXX)
mkfifo $PIPE
exec 3<> $PIPE

# make sure yad isn't already running (change if you use yad for other things)
pkill yad

# start yad with "no connection' icon
yad --notification --kill-parent --listen <&3 &
echo "icon:$INSTALL_DIR/images/nc.png" >&3
echo "visible:blink" >&3
echo "tooltip:DWS_Notifier" >&3
echo "menu:DWS Website!xdg-open http://defconwarningsystem.com\
|Refresh!$INSTALL_DIR/DWS-linux.sh\
|Open Folder!xdg-open $INSTALL_DIR\
|Help!xdg-open https://github.com/AD-Wright/DWS-linux\
|Quit!quit" >&3

# update icon according to last downloaded image
if [ $BLUE == 92 ]; then
    echo "icon:$INSTALL_DIR/images/5.png" >&3

elif [ $BLUE == 254 ]; then
    echo "icon:$INSTALL_DIR/images/4.png" >&3

#elif [ $BLUE == ?? ]; then
#    echo "icon:$INSTALL_DIR/images/3.png" >&3

#elif [ $BLUE == ?? ]; then
#    echo "icon:$INSTALL_DIR/images/2.png" >&3

#elif [ $BLUE == ?? ]; then
#    echo "icon:$INSTALL_DIR/images/1.png" >&3

else
    echo "icon:$INSTALL_DIR/images/nc.png" >&3
    echo "No defcon image - is this the first run? Check INSTALL_DIR"
fi

# main while loop (check DWS every few minutes)
while true; do

# get a copy of the currently downloaded image
FILE='defcon.jpg'
CURRENT_TS=`stat -c %y $FILE`

# run wget to see if image timestamp has changed on server
wget --no-netrc \
 --no-http-keep-alive \
 --no-cookies \
 --user-agent="DWS-linux_test" \
 --directory-prefix="$INSTALL_DIR" \
 --timestamping "https://defconwarningsystem.com/current/defcon.jpg"

# handle wget error
if [ $? != 0 ]; then
    echo "icon:$INSTALL_DIR/images/nc.png" >&3
    echo "wget error: $?"
fi

# check if wget downloaded an updated image
NEW_TS=`stat -c %y $FILE`
if [ "$CURRENT_TS" != "$NEW_TS" ]; then
    # notify user if requested
    if [ $NOTIFY == 1 ]; then
        yad --image "$INSTALL_DIR/defcon.jpg" --title "DEFCON level has changed"
    fi

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

#    elif [ $BLUE == ?? ]; then
#        echo "icon:$INSTALL_DIR/images/3.png" >&3

#    elif [ $BLUE == ?? ]; then
#        echo "icon:$INSTALL_DIR/images/2.png" >&3

#    elif [ $BLUE == ?? ]; then
#        echo "icon:$INSTALL_DIR/images/1.png" >&3

    else
        echo "icon:$INSTALL_DIR/images/nc.png" >&3
        echo "Error in icon assignment"
    fi

fi

# delay time between automatic refreshes, in seconds
sleep $UPDATE_INT

# end loop
done
