# DWS-linux
Defcon Warning System desktop app: for Linux!

#IN-DEVELOPMENT TWITTER BRANCH

This repository provides a simple shell script to generate a icon in the system tray that displays the current defcon status, as determined by [The Defcon Warning System](https://defconwarningsystem.com/). The update interval, as well as notification preferences, can be set in DWS-linux.sh.

Ubuntu users may need to install the "TopIconsPlus" extension through Ubuntu Software -> Add-ons -> Shell Extensions in order to get the system tray icon to display.  The default icon size in this extension should also be set to 16 pixels, if you want the icon to look right.

To "install" this script, place in any user directory (home, Documents, etc.), and update the `INSTALL_DIR` variable in `DWS-linux.sh` to the directory you place it in.  Make sure that the script is also given execution rights, either through `chmod +x DWS-linux.sh` or through checking the tick box in file properties.  To ensure the script is launched every time you turn on your computer, add the script to Startup Applications.

## Dependencies:
- yad (tested 0.38.2) 
  - https://github.com/v1cont/yad
  - `sudo apt-get install yad`
- wget (tested 1.19.4)
  - `sudo apt-get install wget`
- rsstail (tested 1.8) 
  - https://github.com/flok99/rsstail
  - `sudo apt-get install rsstail`
- Uses queryfeed.net to supply the RSS feed
  - https://queryfeed.net/tw?q=%40DEFCONWSALERTS

## Troubleshooting:
Try running the script from the command line.  Navigate to the directory in terminal, then run `./DWS-linux.sh`.  If there is an error message, proceed.
- Wget errors are generally due to internet connectivity or file permission issues.
- If the icon is not showing up in the system tray, try installing the TopIconsPlus shell extension.
- If there is an icon assignment error, let me know - something might be wrong with fetching the current DEFCON state.
- If only the yad icon (a beaker) is showing up, try delaying the autostart by using `bash -c "sleep 10 && <path to script>"`

Uncommenting the DEBUG line will output the read-in value if you want to try some debugging yourself.

## Notes:
This script was developed on an Ubuntu 18.04.2 install, and hasn't yet been tested on anything else.  Feel free to let me know other distros that this successfully works on, I'll add them to this page.

This script will not work on Windows or Android.  Don't know about Macs.  For Windows or Andriod, Defcon Warning System has [an official application](https://defconwarningsystem.com/links-tools/#Applications) that they provide.

Support will be provided as I have time, if I have time.  My time is usually limited, so support may also be limited.  *I am not associated with Defcon Warning System, asking debugging questions on their forums might not be welcome.*

Feature suggestions are welcome, but may not be implemented.  As a consolation, this is open-source and free.
