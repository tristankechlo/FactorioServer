# Update the server to the newest Factorio version
**MAKE AN BACKUP BEFORE STARTING THE UPDATE**

## stop the server
```bash
sudo systemctl stop factorio.service
```

## download the latest updater
```bash
cd /tmp
DOWNLOAD_URL="https://raw.githubusercontent.com/tristankechlo/FactorioServer/main/update.sh"
wget -O factorio_update_server.sh $DOWNLOAD_URL
```

## start the update script
if you don't have an authentication token, use
```bash
sudo bash factorio_update_server.sh -u "username" -p "password"
```
replace `username` and `password` with the credentials used by `factorio.com`  

<hr>

if you have already an authentication token, can be re-used from previous calls, run

```bash
sudo bash factorio_update_server.sh -u "username" -t "token"
```
replace `username` and `token`
