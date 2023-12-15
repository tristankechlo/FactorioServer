#!/bin/bash

# check if script is run as root
if [ "$(id -u)" -ne 0 ]
  then echo -e "\e[1;31mPlease run as root\e[0m";
  exit 1;
fi

echo -e "\033[1;33mPlease make an backup before you start the update!\e[0m"
read -r -p "Are you sure you want to continue? (y|n): " response
response=${response,,}    # tolower
if [[ ! "$response" =~ ^(yes|y)$ ]]
then
  echo -e "\e[1;32mStopping\e[0m"
  exit 1
fi

cd /tmp

PACKAGE="core-linux_headless64"

# get current factorio version
FILE_NAME="/opt/factorio/data/base/info.json"
if [ ! -f "$FILE_NAME" ]; then
  echo -e "\e[1;31mCan not read version from current installation, \033[1;37m$FILE_NAME\e[1;31m does not exist\e[0m"
  exit 1;
else
  VERSION=$(cat $FILE_NAME | python3 -I -c "import sys, json; print(json.load(sys.stdin)['version'])")
fi

echo -e "\e[1;36mFound existing Factorio Version: \e[0m$VERSION"

# read input flags
while getopts u:t: flag
do
  case "${flag}" in
    u) USERNAME="${OPTARG}";;
    t) AUTH_TOKEN="${OPTARG}";;
  esac
done

# check if username is empty
if [ -z "$USERNAME" ]; then
  echo ""
  echo -e "\e[1;31mPlease specify your username with '-u \"username\"'\e[0m"
  exit 1
fi
echo -e "\e[1;36mUsername: \e[0m$USERNAME";

# url encode username
USERNAME=$(python3 -c "import urllib.parse; print(urllib.parse.quote(\"$USERNAME\"))")

# check if token is empty, try getting one with the password
if [ -z "$AUTH_TOKEN" ]; then
    echo ""
    echo -e "\e[1;31mPlease specify your auth-token with '-t \"token\"'\e[0m"
    exit 1
else
  echo -e "\e[1;36mToken: \e[0m********************";
fi


# get all available versions and parse through python
UPDATES_URL="https://updater.factorio.com/get-available-versions?username=$USERNAME&token=$AUTH_TOKEN"

NEEDED_UPDATES=$(curl -s "$UPDATES_URL" | python3 -I -c "
import sys, json;
from pkg_resources import parse_version as version;
lower='$VERSION'
loaded=json.load(sys.stdin)
if 'message' in loaded and 'status' in loaded:
  print(loaded)
  sys.exit(5)
all_versions=loaded['$PACKAGE']
upper=[x for x in all_versions if 'stable' in x][0]['stable']
output=[]
for i in range(0, len(all_versions)):
  upgrade=all_versions[i]
  if 'from' in upgrade and 'to' in upgrade:
    if version(upgrade['from']) >= version(lower) and version(upgrade['to']) <= version(upper):
      output.append('&from='+upgrade['from']+'&to='+upgrade['to'])
print(' '.join(output))
")

if [[ $? -ne 0 ]]; then
  echo ""
  echo -e "\e[1;31mCould not get available updates from API, answer:\e[0m $NEEDED_UPDATES"
  exit 1
fi

# check if there are any new updates available
if [ -z "$NEEDED_UPDATES" ]; then
  echo ""
  echo -e "\e[1;32mNo, updates found. You are uptodate.\e[0m"
  exit 1
else
  # print all found verions
  for UPDATE in $NEEDED_UPDATES
  do
    TMP=${UPDATE//[\&=]/-}
    UPDATE_FILE="update$TMP.zip"
    echo -e "\e[1;36mFound update: \e[0m$UPDATE_FILE"
  done
  # ask fot confirmation
  read -r -p "Do you want to install these updates? (y|n): " response
  response=${response,,}    # tolower
  if [[ ! "$response" =~ ^(yes|y)$ ]]; then
    echo -e "\e[1;32mStopping\e[0m"
    exit 1
  fi
fi

TMP_FOLDER="/tmp/factorio"
echo -e "\e[1;36mCreating temp folder: \e[0m$TMP_FOLDER"
mkdir -p $TMP_FOLDER
cd $TMP_FOLDER
rm -rf "update-*"

DOWNLOAD_UPDATES_URL="https://updater.factorio.com/get-download-link?username=$USERNAME&token=$AUTH_TOKEN&package=$PACKAGE"
echo -e "\e[1;36mStarting downloads\e[0m"

# collect all files names in this variable
FILES=""

# download each file
for OUTPUT in $NEEDED_UPDATES
do
  # get file link from api
  LINK_TO_UPDATE=$(curl -s -f "$DOWNLOAD_UPDATES_URL$OUTPUT")
  LINK_TO_UPDATE=${LINK:2:-2}
  TMP=${OUTPUT//[\&=]/-}
  UPDATE_FILE="update$TMP.zip"
  FILES+=" $UPDATE_FILE"
  echo -e "\e[1;36mDownloading file: \e[0m$UPDATE_FILE"
  wget -O $UPDATE_FILE -q $LINK_TO_UPDATE
done

echo -e "\e[1;36mDownloads finished\e[0m"
echo -e "\e[1;36mApplying updates\e[0m"

# apply each update
for FILE in $FILES
do
  echo -e "\e[1;36mApplying update: \e[0m$TMP_FOLDER/$FILE"
  /opt/factorio/bin/x64/factorio --apply-update "$TMP_FOLDER/$FILE"
done

echo -e "\e[1;36mDeleting temp files inside \e[0m$TMP_FOLDER"
cd $TMP_FOLDER
rm -rf update-*

echo -e "\e[1;32mDONE\e[0m"
exit 0

