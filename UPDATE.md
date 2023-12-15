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
<!-- reading options from a file  
create a `.properties` file with following contents  

```properties
USERNAME="Username"
AUTH_TOKEN="ReplaceWithActualToken"
```
and then start the update script with these options
```bash
sudo bash factorio_update_server.sh -f "/path/to/.properties"
```

<hr>
  
you can also pass those options directly through some flags-->
```bash
sudo bash factorio_update_server.sh -u "username" -t "token"
```
replace `username` and `token` with your username and token used by `factorio.com`  
