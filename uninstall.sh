#!/bin/bash

# check if script is run as root
if [ "$(id -u)" -ne 0 ]
  then echo -e "\e[1;31mPlease run as root\e[0m";
  exit 1;
fi

echo -e "\033[1;31mUninstalling the Factorio Server will also remove all savegames currently inside \e[0m/opt/factorio\e[1;31m, so make backups if you want to keep them.\e[0m"
read -r -p "Are you sure you want to continue? (y|n): " response
response=${response,,}    # tolower
if [[ ! "$response" =~ ^(yes|y)$ ]]
then
  echo -e "\e[1;32mStopping\e[0m"
  exit 1
fi

echo -e "\e[1;36mRemoving systemd service\e[0m"
systemctl stop factorio.service
systemctl disable factorio.service
rm -rf /etc/systemd/system/factorio.service
systemctl daemon-reload

echo -e "\e[1;36mDeleting \e[0m/opt/factorio"
rm -rf /opt/factorio

echo -e "\e[1;36mDeleting \e[0m/tmp/factorio_install_server.sh"
rm -rf /tmp/factorio_install_server.sh

echo -e "\e[1;36mDeleting \e[0m/tmp/factorio_update_server.sh"
rm -rf /tmp/factorio_update_server.sh

echo -e "\e[1;36mDeleting \e[0m/tmp/factorio_uninstall_server.sh"
rm -rf /tmp/factorio_uninstall_server.sh

echo -e "\e[1;32mDONE\e[0m"
exit 0
