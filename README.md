# How to install a Factorio server?
This is a somewhat personal guide on how to setup and manage a Factorio Server.  
It is specialized to work on specific systems. It might work for you, or it might not.  
  
**No support and no guarantees.**  
  
Savegames are `.zip` files usually located in  
 - Windows `%appdata%\Factorio\saves`
 - Linux `~/.factorio/saves`
 - MacOSX `~/Library/Application Support/factorio/saves`
  
Requirements for the setup:
 - any linux distribution that supports `systemd`
 - `wget`, `curl`, `python3` need to be installed

## download install script
Download the custom install script.  
```bash
cd /tmp
DOWNLOAD_URL="https://raw.githubusercontent.com/tristankechlo/FactorioServer/main/install.sh"
wget -O factorio_install_server.sh $DOWNLOAD_URL
```

## run the install script
```bash
sudo bash factorio_install_server.sh
```
This script will install a headless factorio server on your current system (located at `/opt/factorio`).  
Additionally a Unix-Service, for handling the Factorio-Server, is created, but not yet started.  

## setup your server
You need to do a few things before you can start your server.

### copy necessary files
- move your existing `savegame.zip` into `/opt/factorio/saves`
- place your mods (if any) into `/opt/factorio/mods`

### adjust settings
Before you start the server, you may need to adjust some settings for the server.  
The file can be found at `/opt/factorio/data/server-settings.json`.  
Those settings are used when the server is started.

## start the server
Start the Unix-Service that controls the factorio server.
```bash
sudo systemctl start factorio.service
```

### see the server status
```bash
sudo systemctl status factorio.service
```

### setup autoload on systemboot
This will start your server as soon your system boots and has a network connection.  
Use the second command only if your server is not already running.
```bash
sudo systemctl enable factorio.service
sudo systemctl start factorio.service
```

## How to stop the server?
```bash
sudo systemctl stop factorio.service
```
This stops the server temporary, if you enabled autostart it will still restart when you reboot your system.  
To disable that too, use
```bash
sudo systemctl disable factorio.service
```
