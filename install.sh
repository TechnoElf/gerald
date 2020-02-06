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

echo "====================="
echo "Gerald Install Script"
echo "====================="
echo ""

INSTALL_FROM=$(pwd)
INSTALL_TARGET_ROOT="/opt/gerald/"
ONEDRIVE_CONFIG="${INSTALL_TARGET_ROOT}/config/onedrive/"
ONEDRIVE_REMOTE="${INSTALL_TARGET_ROOT}/remote"

if [ ! -f $INSTALL_TARGET_ROOT ]; then
  sudo mkdir $INSTALL_TARGET_ROOT
  sudo chown $USER $INSTALL_TARGET_ROOT
fi
cd $INSTALL_TARGET_ROOT

echo "Installing Gerald..."
git clone https://github.com/TechnoElf/gerald.git
echo "Installed"

echo "Installing dependencies..."
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  sleep 0.5
done
sudo apt update
sudo apt install -y git fbi omxplayer
echo "Installed"

echo "Installing OneDrive..."
if [ ! -f ${INSTALL_TARGET_ROOT}/onedrive ]; then
  bash ${INSTALL_TARGET_ROOT}/gerald/build_onedrive.sh
fi

if [ ! -f $ONEDRIVE_CONFIG ]; then
  mkdir -p $ONEDRIVE_CONFIG
fi

if [ ! -f $ONEDRIVE_CONFIG ]; then
  mkdir $ONEDRIVE_REMOTE
fi

if [ ! -f ${ONEDRIVE_CONFIG}/config ]; then
  touch ${ONEDRIVE_CONFIG}/config
  echo -e "\nsync_dir = \"${ONEDRIVE_REMOTE}\"\n" >> ${ONEDRIVE_CONFIG}/config
fi

if [ ! -f ${ONEDRIVE_CONFIG}/sync_list ]; then
  touch ${ONEDRIVE_CONFIG}/sync_list
  echo "Remote folder path:"
  read -e ONEDRIVE_REMOTE_DIR
  echo -e "$ONEDRIVE_REMOTE_DIR\n" >> ${ONEDRIVE_CONFIG}/sync_list
fi
echo "Installed"

echo "Run ${INSTALL_TARGET_ROOT}gerald/configure.sh to complete the setup"
