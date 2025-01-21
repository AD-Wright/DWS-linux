# DWS-linux
Defcon Warning System desktop app: for Linux!

#### What is DWS-linux?

This repository provides a simple shell script to generate a icon in the system tray that displays the current defcon status, as determined by [The Defcon Warning System](https://defconwarningsystem.com/). By default, notifications are also generated each time the defcon status changes.  The update interval, as well as notification preferences, can be set in the "User Configuration" section of `DWS-linux.sh`.  The tray icon can be disabled as well, leaving a "headless" version with just the notification pop-ups.  This headless version only has `notify-send` and `wget` as dependencies, so if you have issues with `yad` you can still have some functionality.

To "install" this script, download the repository into any user directory (home, Documents, etc.), and update the `INSTALL_DIR` variable in `DWS-linux.sh` to the directory of the repository (e.g. `~/Documents/DWS-linux`).  Make sure that the scripts are also given execution rights, either through `chmod +x DWS-linux.sh` or through checking the tick box in file properties.  To ensure the script is launched every time you turn on your computer, add the `DWS-linux.sh` script to Startup Applications or the like.  

There is also a utility menu if you right-click on the tray icon, with links to the [DWS webpage](https://defconwarningsystem.com), [DWS Forums](https://community.defconwarningsystem.com), the `install` folder on your computer, a refresh command, etc.

## Dependencies:
- `yad` (tested 0.40.0 (GTK+ 3.24.20)) 
  - https://github.com/v1cont/yad
  - `sudo apt-get install yad`
- `wget` (tested 1.20.3)
  - `sudo apt-get install wget`  
- `notify-send` (tested 0.7.9)
  - `sudo apt-get install libnotify-bin`

## Troubleshooting:
*I am not associated with Defcon Warning System, please ask for support here rather than on their forums.*

Ubuntu users will probably need to install the "TopIconsPlus" extension through Ubuntu Software -> Add-ons -> Shell Extensions in order to get the system tray icon to display.  The default icon size in this extension should also be set to 16 pixels, if you want the icon to look right.  

If the icon is grey, and displays a number sign (`#`) crossed out, then either there is no internet connection, or the DWS servers are down.  

If the script fails to run, try running the script from the command line.  Navigate to the directory in terminal, then run `./DWS-linux.sh`.  If there is an error message, proceed with debugging from there.
- Wget errors are generally due to internet connectivity or file permission issues.
- If the icon is not showing up in the system tray, try installing the TopIconsPlus shell extension.
- If only the yad icon (a beaker) is showing up, try delaying the autostart by using `bash -c "sleep 10 && <path to script>"`.  You can also right-click the icon for a menu and select "refresh" on every startup.

## Notes:
This script is used daily by the developer on an PopOS 22.04 install, and is occasionally tested on other distros.  I have made efforts to try to ensure compatibility across most distributions, but can't guarantee much.  However, if you do have issues on a specific linux distribution, feel free to create an issue and I'll see if I can fix it!

This script will not work on Windows or Android.  I don't have the ability to test it on Macs, but it will probably not work.  For Windows or Andriod, Defcon Warning System has [an official application](https://defconwarningsystem.com/links-tools/#Applications) that they provide.

I would encourage you to donate to [DefconWarningSystem](https://defconwarningsystem.com/) as well.
