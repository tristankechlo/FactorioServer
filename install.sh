#!/bin/bash

# check if script is run as root
if [ "$(id -u)" -ne 0 ]
  then echo -e "\e[1;31mPlease run as root\e[0m";
  exit 1;
fi

# url
DOWNLOAD_FACTORIO="https://factorio.com/get-download/stable/headless/linux64"
DOWNLOAD_SERVICE="https://raw.githubusercontent.com/tristankechlo/FactorioServer/main/factorio.service"

# donwload latest server file to /tmp folder
FILE_NAME="factorio.tar.xz"
cd /tmp
echo -e "\e[1;36mDownloading factorio server file:\e[0m $FILE_NAME"
wget -q -O $FILE_NAME $DOWNLOAD_FACTORIO

echo -e "\e[1;36mDownloading \e[0mfactorio.service"
wget -q -O factorio.service $DOWNLOAD_SERVICE

# unzip server file inside /opt
cd /opt
echo -e "\e[1;36mUnzipping server file:\e[0m /tmp/$FILE_NAME \e[1;36minto:\e[0m/opt/factorio"
tar -xJf "/tmp/$FILE_NAME"
rm -f "/tmp/$FILE_NAME"

# create additional folders
echo -e "\e[1;36mCreating folders and settings files\e[0m"
mkdir -p /opt/factorio/saves
mkdir -p /opt/factorio/mods

# create settings files
mv /opt/factorio/data/server-settings.example.json /opt/factorio/data/server-settings.json
mv /opt/factorio/data/server-whitelist.example.json /opt/factorio/data/server-whitelist.json

# setup system service
echo -e "\e[1;36mCreating systemd service:\e[0m factorio.service"
mv /tmp/factorio.service /etc/systemd/system/factorio.service
systemctl daemon-reload
# dont start by default
systemctl disable factorio.service

# delete zip file
echo -e "\e[1;36mDeleting temporary file:\e[0m /tmp/$FILE_NAME"
rm -f "/tmp/$FILE_NAME"

echo -e "\e[1;32mDONE\e[0m"
exit 0
