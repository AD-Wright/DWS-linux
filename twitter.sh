#!/bin/bash

# filename: twitter.sh
###############################################################################
#                                                                             #
#    DWS-linux: desktop status for defconwarningsystem.com for linux users    #
#    Coded by A.D. Wright - GPLv3 License - github.com/AD-Wright/DWS-linux    #
#                                                                             #
###############################################################################

#THIS IS NOT THE MAIN FILE
# This is a helper script, used to provide the twitter notifications through
# ?notify-send or yad? probably yad
# This file does not need to be autostarted, but it should have exec permission
# in order to be properly triggered by the DWS-linux main script.

# USER CONFIG

# update interval: default 300 (5 minutes)
UPDATE_INT=300

# rss feed url for DEFCONWSALERTS
DWS_URL="https://nitter.net/DEFCONWSALERTS/rss"

# END USER CONFIG

while true; do

# kill existing rsstail processes (change if you use for other things)
pkill rsstail

# use rsstail to check the twitter page, pipe output to yad with some formatting
rsstail -i $UPDATE_INT -u $DWS_URL -n 0 -dNHP | ( read -r T1 T2; read -r T3; notify-send -u critical "DWS_linux" "News: $T3 $T5"; )

#rsstail -i 300 -u "https://nitter.net/DEFCONWSALERTS/rss" -n 1 -dNH 

done;
