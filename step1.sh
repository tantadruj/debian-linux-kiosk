#!/bin/bash

#Set variables 

user="student"
staticip="172.16.9.233"
netmask="255.255.254.0"
gateway="172.16.8.1"
sshport="34666"

#Get network interface

eth=$(ls /sys/class/net | grep enp)
echo "Network interface is $eth"

#Change network settings 

if grep -q "iface $eth inet dhcp" /etc/network/interfaces;
then
    sed -i "s/iface $eth inet dhcp/iface $eth inet static/" /etc/network/interfaces 
    sed -i "/iface $eth inet/a\address $staticip\nnetmask $netmask\ngateway $gateway" /etc/network/interfaces 
    echo "Network configuration done"
else
    echo "No changes to network"
fi

#Change SSH port

if grep -q "#Port 22" /etc/ssh/sshd_config;
then
    sed -i "s/#Port 22/Port $sshport/" /etc/ssh/sshd_config 
    echo "SSH port changed"
else
    echo "No changes to SSH port"
fi

#Install software

echo "Updating package list"
apt-get update -qq > /dev/null 

echo "Installing software, this can take a while"

if apt-get install curl apt-transport-https firmware-linux-free lightdm mpv libreoffice evince xinit x11-xserver-utils openbox obconf lxterminal pcmanfm tint2 compton fonts-arphic-uming fonts-wqy-zenhei fonts-unfonts-core fonts-indic lxappearance git xarchiver mirage -qq > /dev/null
then
    echo "Install succeeded"
else
    echo "Install failed. Fix missing and retry"
    apt-get update --fix-missing
    apt-get -y install curl apt-transport-https firmware-linux-free lightdm mpv libreoffice evince xinit x11-xserver-utils openbox obconf lxterminal pcmanfm tint2 compton fonts-arphic-uming fonts-wqy-zenhei fonts-unfonts-core fonts-indic lxappearance git xarchiver mirage
fi

#Install Brave

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
echo off > /dev/null
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|
tee /etc/apt/sources.list.d/brave-browser-release.list
echo on > /dev/null
echo "Updating package list"
apt-get update -qq > /dev/null 
echo "Installing Brave"
apt-get install brave-browser -qq > /dev/null 

#LightDM autologin

if grep -q "#autologin-user=" /etc/lightdm/lightdm.conf;
then
    sed -i "s/#autologin-user=/autologin-user=$user/" /etc/lightdm/lightdm.conf 
    echo "Autologin done"
else
    echo "No changes to autologin"
fi

#Icons

cd /tmp
echo "Cloning flat-remix"
git clone https://github.com/daniruiz/flat-remix -q > /dev/null 
echo "Copying flat-remix to usr icons, this will take a while"
cp -r flat-remix/Flat-Remix* /usr/share/icons/
echo "Copying done"

#Cron shutdown schedule 
#Each saturday and sunday after 15:00, other days after 22:00

if [[ ! -e /etc/cron.d/shutdown ]];
then
    touch /etc/cron.d/shutdown 
    echo "* 22 * * * root /sbin/shutdown -h +0" >> /etc/cron.d/shutdown
    echo "* 15 * * 0,6 root /sbin/shutdown -h +0" >> /etc/cron.d/shutdown
    chmod 0644 /etc/cron.d/shutdown
    echo "Cron done"
else
    echo "No changes to cron"
fi

#Openbox autostart

if [[ ! -e /home/$user/.config/openbox/autostart.sh ]];
then
mkdir -p /home/$user/.config/openbox
touch /home/$user/.config/openbox/autostart.sh
echo "compton &" >> /home/$user/.config/openbox/autostart.sh
echo "tint2 &" >> /home/$user/.config/openbox/autostart.sh
echo "pcmanfm --desktop &" >> /home/$user/.config/openbox/autostart.sh
echo "xset s off -dpms &" >> /home/$user/.config/openbox/autostart.sh
chown -R $user:$user /home/$user/.config/
echo "Autostart done"
else
echo "No changes to autostart"
fi

#EndOfFile