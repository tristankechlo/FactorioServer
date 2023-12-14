# Uninstall the Factorio Server
If you have any savefiles, or other data you want to keep, inside `/opt/factorio`, make a backup of those files.  
**Otherwise all data will be lost.**

## download the latest uninstaller
```bash
cd /tmp
DOWNLOAD_URL="https://raw.githubusercontent.com/tristankechlo/FactorioServer/main/uninstall.sh"
wget -O factorio_uninstall_server.sh $DOWNLOAD_URL
```

## start the uninstall script
```bash
sudo bash factorio_uninstall_server.sh
```
You will be asked for confirmation. Enter `y` for `yes` or `n` for `no` and press `Enter`
