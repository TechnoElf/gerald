#!/bin/bash

if [[ $EUID -eq 0 ]]; then
   echo "The installer must not be run as root"
   exit 1
fi

wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -ne 0 ]]; then
  echo "The device must be connected to the internet"
  exit 1
fi

if [ -f "onedrive" ]; then
  echo "The onedrive executable must be placed next to the installer (see build_onedrive.sh)"
  exit 1
fi

echo "====================="
echo "Gerald Install Script"
echo "====================="
echo ""
sleep 2s

INSTALL_FROM=$(pwd)
INSTALL_TARGET_ROOT="/opt/gerald/"
ONEDRIVE_CONFIG="${INSTALL_TARGET_ROOT}/config/onedrive/"
ONEDRIVE_REMOTE="${INSTALL_TARGET_ROOT}/remote"

# Create a home for ourselves
sudo mkdir $INSTALL_TARGET_ROOT
sudo chown $USER $INSTALL_TARGET_ROOT
cd $INSTALL_TARGET_ROOT

# Install dependencies
echo "Installing dependencies..."
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  sleep 0.5
done
sudo apt update
sudo apt install -y git fbi omxplayer

# Install onedrive
echo "Installing OneDrive..."
mv ${INSTALL_FROM}/onedrive .
mkdir -p $ONEDRIVE_CONFIG
touch ${ONEDRIVE_CONFIG}/config
echo -e "\nsync_dir = \"${ONEDRIVE_REMOTE}\"\n" >> ${ONEDRIVE_CONFIG}/config
mkdir $ONEDRIVE_REMOTE
touch ${ONEDRIVE_CONFIG}/sync_list
echo "Remote folder path:"
read -e ONEDRIVE_REMOTE_DIR
echo -e "$ONEDRIVE_REMOTE_DIR\n" >> ${ONEDRIVE_CONFIG}/sync_list
./onedrive --confdir $ONEDRIVE_CONFIG
./onedrive --confdir $ONEDRIVE_CONFIG --synchronize --download-only
echo "Installed"

# Finally we get to the actual setup
echo "Installing Gerald"
git clone https://github.com/TechnoElf/gerald.git
sudo sed -ie '/^exit.*/i bash \/opt\/gerald\/gerald\/start.sh &' /etc/rc.local
chmod +x /opt/gerald/gerald/start.sh
echo "Installed"

echo "Setup completed"
echo "Please reboot"
