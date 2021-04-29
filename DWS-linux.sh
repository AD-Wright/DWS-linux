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

# notify if defcon level changes? 
NOTIFY=1   # (0 = no, 1 = yes, default is 1)

# enable / allow checking for updates to the DEFCONWSALERTS Twitter page?
TWITTER=1   # (0 = no, 1 = yes, default is 1)

# run in headless mode? 
# (This option removes yad dependency, but also disables tray icon. Purely 
# notify-send popups for changes in defcon level (and twitter if enabled).)
HEADLESS=1   # (0 = no, 1 = yes, default is 0)

### END USER CONFIGURATION ###

# kill previous instances of this script if still running
kill $(pgrep -f 'DWS-linux.sh' | grep -v ^$$\$)

# start rsstail script only if twitter integration is desired
if [ "$TWITTER" = "1" ]; then
    pkill twitter.sh
    $INSTALL_DIR/twitter.sh &
fi

# grab last known status
DEFCON=$(cat $INSTALL_DIR/code.dat)

# only start yad if needed (for tray icon)
if [ "$HEADLESS" = "0" ]; then

    # start pipe for yad listening on exec 3 (this is how we change the icon)
    PIPE=$(mktemp -u --tmpdir dws_yad.XXXXXX)

    mkfifo "$PIPE"
    exec 3<> "$PIPE"

    # make sure yad isn't already running (change if you use yad for other things)
    pkill yad

    # start yad with "no connection' icon
    yad --notification --listen <&3 &
    echo "icon:$INSTALL_DIR/images/nc.png" >&3
    echo "visible:blink" >&3
    echo "tooltip:DWS_Notifier" >&3
    echo "menu:DWS Website!xdg-open https://defconwarningsystem.com\
|DWS Twitter!xdg-open https://twitter.com/DEFCONWSALERTS\
|Refresh!$INSTALL_DIR/DWS-linux.sh\
|Open Folder!xdg-open $INSTALL_DIR\
|Help!xdg-open https://github.com/AD-Wright/DWS-linux\
|Quit!quit" >&3

    # update yad with correct icon
    if [ "$DEFCON" = "5" ]; then
        echo "icon:$INSTALL_DIR/images/5.png" >&3
        cp $INSTALL_DIR/images/5.png $INSTALL_DIR/images/current.png

    elif [ "$DEFCON" = "4" ]; then
        echo "icon:$INSTALL_DIR/images/4.png" >&3
        cp $INSTALL_DIR/images/4.png $INSTALL_DIR/images/current.png

    elif [ "$DEFCON" = "3" ]; then
        echo "icon:$INSTALL_DIR/images/3.png" >&3
        cp $INSTALL_DIR/images/3.png $INSTALL_DIR/images/current.png

    elif [ "$DEFCON" = "2" ]; then
        echo "icon:$INSTALL_DIR/images/2.png" >&3
        cp $INSTALL_DIR/images/2.png $INSTALL_DIR/images/current.png

    elif [ "$DEFCON" = "1" ]; then
        echo "icon:$INSTALL_DIR/images/1.png" >&3
        cp $INSTALL_DIR/images/1.png $INSTALL_DIR/images/current.png

    else
        echo "icon:$INSTALL_DIR/images/nc.png" >&3
        cp $INSTALL_DIR/images/nc.png $INSTALL_DIR/images/current.png
        echo "Error in icon assignment - ignore if first run"
    fi
fi
# main while loop (check DWS every few minutes)
while true; do

# get a copy of the current index
OLD_CODE=$DEFCON

# run wget to update code.dat
wget "https://defconwarningsystem.com/code.dat" -O "$INSTALL_DIR/code.dat"

# handle wget error (for tray icon)
if [ "$HEADLESS" = "0" ]; then
    if [ $? != 0 ]; then
        echo "icon:$INSTALL_DIR/images/nc.png" >&3
        echo "wget error: $?"
    fi
fi

# check if wget downloaded an updated defcon index
DEFCON=$(cat $INSTALL_DIR/code.dat)
if [ "$OLD_CODE" != "$DEFCON" ]; then
    # notify user if requested
    if [ "$NOTIFY" = "1" ] && [ "$DEFCON" != "" ] && [ "$OLD_CODE" != "" ]; then
        notify-send -u critical -i "$INSTALL_DIR/images/$DEFCON.png" "DEFCON level has changed"
    fi
    
    # (for tray icon)
    if [ "$HEADLESS" = "0" ]; then
        # check that yad is still running, exit if not
        if ! pgrep "yad" >/dev/null; then
            pkill twitter.sh
            pkill rsstail
            exit
        fi

        # update yad with correct icon
        if [ "$DEFCON" = "5" ]; then
            echo "icon:$INSTALL_DIR/images/5.png" >&3
            cp $INSTALL_DIR/images/5.png $INSTALL_DIR/images/current.png

        elif [ "$DEFCON" = "4" ]; then
            echo "icon:$INSTALL_DIR/images/4.png" >&3
            cp $INSTALL_DIR/images/4.png $INSTALL_DIR/images/current.png

        elif [ "$DEFCON" = "3" ]; then
            echo "icon:$INSTALL_DIR/images/3.png" >&3
            cp $INSTALL_DIR/images/3.png $INSTALL_DIR/images/current.png

        elif [ "$DEFCON" = "2" ]; then
            echo "icon:$INSTALL_DIR/images/2.png" >&3
            cp $INSTALL_DIR/images/2.png $INSTALL_DIR/images/current.png

        elif [ "$DEFCON" = "1" ]; then
            echo "icon:$INSTALL_DIR/images/1.png" >&3
            cp $INSTALL_DIR/images/1.png $INSTALL_DIR/images/current.png

        else
            echo "icon:$INSTALL_DIR/images/nc.png" >&3
            cp $INSTALL_DIR/images/nc.png $INSTALL_DIR/images/current.png
            echo "Error in icon assignment"
        fi
    fi
fi

# delay time between automatic refreshes, in seconds
sleep $UPDATE_INT

# end loop
done
