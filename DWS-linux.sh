#!/bin/sh

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

# update interval: default 60 (1 minute), please don't use a shorter interval
UPDATE_INT=60

# notify if defcon level changes? (0 = no, 1 = yes)
NOTIFY=1

### END USER CONFIGURATION ###

# grab last known status
DEFCON=$(cat code.dat)

# for ease of determining read value: 5,4,3,2,1 (DEBUG)
#echo $DEFCON

# start pipe for yad listening on exec 3 (this is how we change the icon)
PIPE=$(mktemp -u --tmpdir "${0##*/}".XXXXXXXX)
mkfifo "$PIPE"
exec 3<> "$PIPE"

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

# update yad with correct icon
    if [ "$DEFCON" = "5" ]; then
        echo "icon:$INSTALL_DIR/images/5.png" >&3

    elif [ "$DEFCON" = "4" ]; then
        echo "icon:$INSTALL_DIR/images/4.png" >&3

    elif [ "$DEFCON" = "3" ]; then
        echo "icon:$INSTALL_DIR/images/3.png" >&3

    elif [ "$DEFCON" = "2" ]; then
        echo "icon:$INSTALL_DIR/images/2.png" >&3

    elif [ "$DEFCON" = "1" ]; then
        echo "icon:$INSTALL_DIR/images/1.png" >&3

    else
        echo "icon:$INSTALL_DIR/images/nc.png" >&3
        echo "Error in icon assignment - ignore if first run"
    fi

# main while loop (check DWS every few minutes)
while true; do

# check that yad is still running, exit if not
if ! pgrep "yad" >/dev/null; then
    exit
fi

# get a copy of the current index
OLD_CODE=$DEFCON

# run wget to update code.dat
wget "https://defconwarningsystem.com/code.dat" -O "$INSTALL_DIR/code.dat"

# handle wget error
if [ $? != 0 ]; then
    echo "icon:$INSTALL_DIR/images/nc.png" >&3
    echo "wget error: $?"
fi

# check if wget downloaded an updated defcon index
DEFCON=$(cat code.dat)
if [ "$OLD_CODE" != "$DEFCON" ]; then
    # notify user if requested
    if [ "$NOTIFY" = "1" ]; then
	wget --directory-prefix="$INSTALL_DIR" \
 --timestamping "https://defconwarningsystem.com/current/defcon.jpg"
        yad --image "$INSTALL_DIR/defcon.jpg" \
 --title "DEFCON level has changed" \
 --no-buttons
    fi

    # update yad with correct icon
    if [ "$DEFCON" = "5" ]; then
        echo "icon:$INSTALL_DIR/images/5.png" >&3

    elif [ "$DEFCON" = "4" ]; then
        echo "icon:$INSTALL_DIR/images/4.png" >&3

    elif [ "$DEFCON" = "3" ]; then
        echo "icon:$INSTALL_DIR/images/3.png" >&3

    elif [ "$DEFCON" = "2" ]; then
        echo "icon:$INSTALL_DIR/images/2.png" >&3

    elif [ "$DEFCON" = "1" ]; then
        echo "icon:$INSTALL_DIR/images/1.png" >&3

    else
        echo "icon:$INSTALL_DIR/images/nc.png" >&3
        echo "Error in icon assignment"
    fi

fi

# delay time between automatic refreshes, in seconds
sleep $UPDATE_INT

# end loop
done
