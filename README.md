# Debian Linux Kiosk

A setup process for public access computer(s). Possible uses are browsing the web and reading or editing documents, this includes the use of a USB key - if you allow it.

Intended for casual Linux users, such as myself.

## Step 1

This step assumes the computer has a password protected BIOS [password protection should include the boot menu],  Debian 11 with the SSH server and standard system utilities installed. Nothing else.

This step assumes that, aside from the root user, there is an unprivileged user called *student*, but it can also be anything else, as long as you modify the *step1.sh* accordingly.

Modifications to example values of the variables in *step1.sh* should be made if, for no other reason, to make it compatible with your network and to select your desired SSH port.

Or you can simply opt for DHCP, but given the public access to the computers, it is better to assign them a static IP address. It is good to know which computer the death threats were being sent from. It also helps with any later management using Ansible and such.

You might also want to modify the cron for when the computers should shutdown or add tasks of your own.

Once you make all the modifications to your liking, as root, run the *step1.sh* which will:

1. modify the network settings
1. modify SSH port
1. install the desired software
1. configure auto-login for *student*
1. fetch icons [just cosmetics]
1. configure cron tasks for automatic shutdown
1. configure auto-start for Openbox

Openbox auto-start includes disabling the screen saver. From my experience it is better if you know a blank screen is trouble or not.

Once that is done, reset the system and proceed to the next step.

## Step 2

First part of this step is manual = mouse clicking. It involves setting up the desktop environment.

Change the following:

Desktop preferences

- Desktop Icons: uncheck Trash Can
- Advanced: check show window manager menu

ObConf

- Theme: Clearlooks
- Desktops: 1

PCManFm Preferences

- pull out desired app shortcuts on Desktop [Brave browser, LibreOffice]
- rename shortcuts to your liking [Internet, Office]
- General: check don't ask options on launch executable file
- Display: size of big icons 128
- Layout: Show in Places: Home Folder only

Tint2 settings

- Panel: uncheck ignore compositor
- Panel items: remove Launcher
- Taskabr: uncheck show desktop name

Look and Feel

- Widget: Clearlooks
- Icon Theme: Flat-Remix-Blue-Dark

Brave Web Browser

On startup:

- Open the New Tab page

Clear browsing data -> On exit:

- history
- cookies
- passwords

Appearance:

- Show bookmarks

Addons:

- ublock origin

Add bookmarks:

- https://github.com/
- etc

Once the manual part is done, as root, run *step2.sh*

Again, it is assumed the user is named *student*.

The script will:

1. make an archive of student's Brave browser directory
1. configure a service and a script, which will overwrite the student's Brave folder with files from the archive, on each boot
1. disable the Openbox right click menu
1. lock the user's desktop, preventing changes like deleting shortcut icons


Any modifications, anyone might make to the Brave browser, will get undone on each boot.

## Step 3

This step is completely optional.

It assumes that, instead of just five, you have fifty or more such computers, with static IP addresses.

`nano /etc/network/interfaces` ? No.

It also assumes you have a MAC address for each computer stored in the file called *iplist*. See the file contents for example values.

Get MAC address CLI command:

`ip link show $ETH | awk '/ether/ {print $2}'`

Script *step3.sh* will check, on boot, if MAC address of the computer matches the provided IP in the *iplist*, based on computer's current IP, and if it does not, it will act accordingly.

It will change the computer's IP, host name and hosts based on its MAC address, so you won't have to, so you can do multicast install using software such as Clonezilla.

Apply *step3.sh* manually, as root.

`nano /usr/local/bin/iplist`

`nano /usr/local/bin/step3.sh`

`chmod u+x /usr/local/bin/step3.sh`

`nano /etc/systemd/system/step3.service`

`systemctl enable /etc/systemd/system/step3.service`

`systemctl daemon-reload`

## Conclusion

The system configured in this way should hopefully be more or less bulletproof. The user should not be able to abuse the system. If you find the potential for a serious abuse please let me know.

The user can still change the names of shortcut icons on desktop, but that is not a detrimental problem, yet it is or can be an annoyance.

There is also a question of data if you decide to permit the use of a USB key. You might want to consider limiting to where the user can write and or occasionally/regularly wipe the data. Issues may occur if you put too many restraints on where the user may write.

If you decide to disallow USB keys either properly secure the computer case or disable USB functionality in BIOS, but then have a motherboard with PS2 ports along with suitable mouse and keyboard.