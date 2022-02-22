#!/bin/bash

# filename: twitter.sh
###############################################################################
#                                                                             #
#    DWS-linux: desktop status for defconwarningsystem.com for linux users    #
#    Coded by A.D. Wright - GPLv3 License - github.com/AD-Wright/DWS-linux    #
#                                                                             #
###############################################################################

# THIS IS NOT THE MAIN FILE
# This is a helper script, used to provide the twitter notifications through
# notify-send and an rss feed.  This feed is hosted by me, and may briefly go
# down at times.  If desired, the feed url can be pointed at an rss provider 
# of your choice, I have used nitter in the past, but it sometimes seems to 
# error out.
# This file does not need to be autostarted, but it should have exec permission
# in order to be properly triggered by the DWS-linux main script.

### BEGIN USER CONFIG ###
# installed directory (update after installation)
INSTALL_DIR=~/Documents/DWS-linux

# update interval for the twitter feed: default 300 (5 minutes in seconds)
# (The default feed I provide has a cache time of 1 minute, so <60 is no bueno)
UPDATE_INT=300

# rss feed url for DEFCONWSALERTS
# (This is a site I provide, since Twitter has removed rss options. You can also
# point this at a Nitter instance or a personal twitter2rss page (see README).
DWS_URL="https://defcon.ironeagl.com/dws-linux.xml"

### END USER CONFIG ###

# Check last rss.xml download
TITLE=$( grep -som2 '<title>[^<]*' $INSTALL_DIR/dws-linux.xml | tail -n1 | grep -so '[^>]*$')
LINK=$( grep -som2 '<link>[^<]*' $INSTALL_DIR/dws-linux.xml | tail -n 1 | grep -so '[^>]*$')
DESCRIPTION=$( grep -som2 '<description>[^<]*' $INSTALL_DIR/dws-linux.xml | tail -n 1 | grep -so '[^>]*$')

while true; do

# Re-download rss.xml (but only if file has changed on server)
wget -Nq $DWS_URL

# Grab new message link (links are unique for tweets)
NEW_LINK=$( grep -som2 '<link>[^<]*' $INSTALL_DIR/dws-linux.xml | tail -n 1 | grep -so '[^>]*$')

# If not the same, then display popup using notify-send
if [[ "$NEW_LINK" != "$LINK" ]]; then
    TITLE=$( grep -som2 '<title>[^<]*' $INSTALL_DIR/dws-linux.xml | tail -n1 | grep -so '[^>]*$')
    LINK=$( grep -som2 '<link>[^<]*' $INSTALL_DIR/dws-linux.xml | tail -n1 | grep -so '[^>]*$')
    DESCRIPTION=$( grep -som2 '<description>[^<]*' $INSTALL_DIR/dws-linux.xml | tail -n1 | grep -so '[^>]*$')
    # Convert some html number codes to prettify
    TITLE=$( echo $TITLE | sed 's/&amp;/\&/g; s/&lt;/\</g; s/&gt;/\>/g; s/&quot;/\"/g; s/&#39;/\'"'"'/g; s/&#34;/\"/g;' ) 
    DESCRIPTION=$( echo $DESCRIPTION | sed 's/&amp;/\&/g; s/&lt;/\</g; s/&gt;/\>/g; s/&quot;/\"/g; s/&#39;/\'"'"'/g; s/&#34;/\"/g;' | sed 's/<a href=\"//g; s/">/ /g; s/img src=\"\([a-z]*\).*\"//g; s/<\/\([a-z]*\)>//g; s/<br>//g;' )
    # Send the notification
    notify-send -u critical -i $INSTALL_DIR/images/current.png "$TITLE" "$DESCRIPTION \n $LINK"

# Else, wait for UPDATE_INT
else
    sleep $UPDATE_INT
fi
done;
