# DWS-linux
Defcon Warning System desktop app: for Linux!

This repository provides a simple shell script to generate a icon in the system tray that displays the current defcon status, as determined by [The Defcon Warning System](https://defconwarningsystem.com/). By default, notifications are also generated each time the defcon status changes, and whenever a new tweet is posted on the [DEFCONWSALERTS](https://twitter.com/DEFCONWSALERTS) Twitter page.  The update interval, as well as notification preferences, can be set in DWS-linux.sh.  

Twitter checks can be disabled, and in fact the tray icon can too, leaving a "headless" version with just the notifications.  In the interest of full disclosure, since Twitter has disabled the rss feed option, the solution I found involved hosting my own rss feed at [defcon.ironeagl.com](https://defcon.ironeagl.com/dws-linux.xml).  I use a slightly modified version of [twitter2rss](https://github.com/n0madic/twitter2rss) that has a caching time of 1 minute to enable reasonable update speed.  If you dislike this, you can disable the twitter feature entirely in the DWS-linux.sh config section, or change the url to an rss feed of your liking in the twitter.sh config section.

To "install" this script, download the repository into any user directory (home, Documents, etc.), and update the `INSTALL_DIR` variable in `DWS-linux.sh` to the directory of the repository (e.g. `~/Documents/DWS-linux`).  Make sure that the scripts are also given execution rights, either through `chmod +x DWS-linux.sh` and `chmod +x twitter.sh` or through checking the tick box in file properties.  To ensure the script is launched every time you turn on your computer, add the `DWS-linux.sh` script to Startup Applications or the like (`twitter.sh` auto-starts if needed).  

There is also a utility menu if you right-click on the tray icon, with links to the DWS webpage, DWS twitter, the local folder on your computer, a refresh command, etc.

## Dependencies:
- yad (tested 0.38.2) 
  - https://github.com/v1cont/yad
  - `sudo apt-get install yad`
- wget (tested 1.19.4)
  - `sudo apt-get install wget`  
- notify-send
  - `sudo apt-get install libnotify-bin`

## Troubleshooting:
*I am not associated with Defcon Warning System, please ask for support here rather than on their forums.*

Ubuntu users may need to install the "TopIconsPlus" extension through Ubuntu Software -> Add-ons -> Shell Extensions in order to get the system tray icon to display.  The default icon size in this extension should also be set to 16 pixels, if you want the icon to look right.

Try running the script from the command line.  Navigate to the directory in terminal, then run `./DWS-linux.sh`.  If there is an error message, proceed.
- Wget errors are generally due to internet connectivity or file permission issues.
- If the icon is not showing up in the system tray, try installing the TopIconsPlus shell extension.
- If there is an icon assignment error, let me know - something might be wrong with fetching the current DEFCON state.
- If only the yad icon (a beaker) is showing up, try delaying the autostart by using `bash -c "sleep 10 && <path to script>"`.  You can also right-click the icon for a menu and select "refresh".

## Notes:
This script was developed on an Ubuntu 18.04.4 install, and is occasionally tested on other distros.  I have made efforts to try to ensure compatibility across most distributions, but can't guarantee much.  However, if you do have issues on a specific linux distribution, feel free to create an issue and I'll see if I can fix it!

This script will not work on Windows or Android.  Don't know about Macs.  For Windows or Andriod, Defcon Warning System has [an official application](https://defconwarningsystem.com/links-tools/#Applications) that they provide.



If you really like this program, I do take donations in [Monero](https://www.getmonero.org/).  
Monero Address: 85SCc5H1dBC7y5gwkrUc11KapJCBDfYu3Se5p7LCrqiRevCdBmUnnrMN12dPW8zcqzgm3ksq3XzdSRnkQkzrZnMd9H2qjvP
