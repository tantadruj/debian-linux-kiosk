#!/bin/bash

ETH=$(ls /sys/class/net | grep enp)
MAC=$(ip link show $ETH | awk '/ether/ {print $2}')
IP=$(ip addr show $ETH | awk '/inet / {print $2}' | cut -d/ -f 1)
HOST=$(hostname)

while read -r f1 f2 f3; do #column1-ip column2-mac column3-last octet
if [[ $MAC = "$f2" ]] && [[ $IP != "$f1" ]];
    then
    sed -i "s/$HOST/st$f3/" /etc/hostname 
    sed -i "s/$HOST/st$f3/" /etc/hosts 
    sed -i "s/$IP/$f1/" /etc/network/interfaces 
    shutdown -r now
fi
done < /usr/local/bin/iplist

#EndOfFile