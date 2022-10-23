# DWS-linux
Defcon Warning System desktop app: for Linux!

This repository provides a simple shell script to generate a icon in the system tray that displays the current defcon status, as determined by [The Defcon Warning System](https://defconwarningsystem.com/). By default, notifications are also generated each time the defcon status changes, and whenever a new tweet is posted on the [DEFCONWSALERTS](https://twitter.com/DEFCONWSALERTS) Twitter page.  The update interval, as well as notification preferences, can be set in the "User Configuration" section of `DWS-linux.sh`.  Twitter checks can be disabled, and in fact the tray icon can be disabled as well, leaving a "headless" version with just the notification pop-ups.  This headless version only has `notify-send` and `wget` as dependencies, so if you have issues with `yad` you can still have some functionality.

In the interest of full disclosure, since Twitter has disabled the rss feed option, the solution I found involved hosting my own rss feed at [defcon.ironeagl.com](https://defcon.ironeagl.com/dws-linux.xml).  I use a slightly modified version of [twitter2rss](https://github.com/n0madic/twitter2rss) that has a caching time of 1 minute to enable reasonable update speed.  If you dislike this, you can disable the twitter feature entirely in the DWS-linux.sh config section, or change the url to an rss feed of your liking in the twitter.sh config section.  

Example alternative rss sources:
- `https://nitter.net/DEFCONWSALERTS/rss`  (~10 minute cache time, it seems.  Too-frequent requests may lead to you being blocked.)
- `https://<twitter2rss>/DEFCONWSALERTS?count=5&exclude_replies=on` (choose your own cache time by hosting your own image)
	- Github page here: [twitter2rss](https://github.com/n0madic/twitter2rss)
	- Docker image here: [dockerhub](https://hub.docker.com/r/n0madic/twitter2rss)
- [Many other options](https://duckduckgo.com/?q=twitter+rss+feed)

To "install" this script, download the repository into any user directory (home, Documents, etc.), and update the `INSTALL_DIR` variable in `DWS-linux.sh` and `twitter.sh` to the directory of the repository (e.g. `~/Documents/DWS-linux`).  Make sure that the scripts are also given execution rights, either through `chmod +x DWS-linux.sh` and `chmod +x twitter.sh` or through checking the tick box in file properties.  To ensure the script is launched every time you turn on your computer, add the `DWS-linux.sh` script to Startup Applications or the like (`twitter.sh` will auto-start if needed).  

There is also a utility menu if you right-click on the tray icon, with links to the [DWS webpage](https://defconwarningsystem.com), [DWS Forums](https://community.defconwarningsystem.com), [DWS twitter](https://twitter.com/DEFCONWSALERTS), the `install` folder on your computer, a refresh command, etc.

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
This script is used daily by the developer on an Ubuntu 20.04 install, and is occasionally tested on other distros.  I have made efforts to try to ensure compatibility across most distributions, but can't guarantee much.  However, if you do have issues on a specific linux distribution, feel free to create an issue and I'll see if I can fix it!

This script will not work on Windows or Android.  I don't have the ability to test it on Macs, but it will probably not work.  For Windows or Andriod, Defcon Warning System has [an official application](https://defconwarningsystem.com/links-tools/#Applications) that they provide.

If you really like this program, I do take donations in [Monero](https://www.getmonero.org/), only because I incur a (very small) cost in providing the Twitter feed.  
Monero Address: `496oKUfbedq6WP6EffFbjy6RmHxE2mpFKeJxPTZ9dtHzisq6yv6AsDT871TGxWG3cXNr3b5nnvg6E14RtvYcNNsb1FMDvJ9`

I would encourage you to donate to [DefconWarningSystem](https://defconwarningsystem.com/) as well.
