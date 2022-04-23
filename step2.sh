#!/bin/bash

user="student"

#Brave user folder backup

echo "Making Brave user folder archive"

cd /home/$user/.config/
tar -czf bb BraveSoftware

echo "Brave user folder archive done"

#Brave restore user folder script and service

touch /usr/local/bin/brave.sh 
chmod u+x /usr/local/bin/brave.sh
touch /etc/systemd/system/brave.service

echo "#!/bin/bash" >> /usr/local/bin/brave.sh
echo "cd /home/$user/.config/" >> /usr/local/bin/brave.sh
echo "tar -xf bb" >> /usr/local/bin/brave.sh  
echo "#EndOfFile" >> /usr/local/bin/brave.sh

echo "[Unit]" >> /etc/systemd/system/brave.service 
echo "Description= Brave" >> /etc/systemd/system/brave.service 
echo "[Service]" >> /etc/systemd/system/brave.service
echo "ExecStart=/usr/local/bin/brave.sh" >> /etc/systemd/system/brave.service
echo "[Install]" >> /etc/systemd/system/brave.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/brave.service

systemctl enable /etc/systemd/system/brave.service > /dev/null
systemctl daemon-reload

echo "Brave restore script and service done"

#Disable Openbox menu

cd /home/$user/.config/openbox 
mv rc.xml rc.lock
cd /etc/xdg/openbox
mv rc.xml rc.lock
mv menu.xml menu.lock 

echo "Openbox menu disabled"

#Lock user's desktop

chown root:root /home/$user/Desktop 

echo "Desktop locked"

#EndOfFile