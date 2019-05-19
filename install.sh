#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "The installer must be run as root"
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
echo "This script will take some time to install and the system may restart multiple times"
echo ""
sleep 2s

# Install dependencies
echo "Installing dependencies..."
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  sleep 0.5
done
apt update
apt install -y git fbi omxplayer onedrive libcurl4-openssl-dev libsqlite3-dev libxml2

echo "Installing OneDrive..."

# Create a home for ourselves
mkdir /opt/gerald
cd /opt/gerald

# Install LDC
wget https://github.com/ldc-developers/ldc/releases/download/v1.13.0/ldc2-1.13.0-linux-armhf.tar.xz
tar -xvf ldc2-1.13.0-linux-armhf.tar.xz
rm ldc2-1.13.0-linux-armhf.tar.xz

# Install onedrive
git clone https://github.com/abraunegg/onedrive.git
cd onedrive
./configure DC=/opt/gerald/ldc2-1.13.0-linux-armhf/bin/ldmd2
make
make install
mkdir -p /home/pi/.config/onedrive
cp config /home/pi/.config/onedrive/.
echo -e "\nsync_dir = \"/opt/gerald/remote/\"\n" >> /home/pi/.config/onedrive/config
mkdir /opt/gerald/remote/
touch /home/pi/.config/onedrive/sync_list
echo "Remote folder path:"
read -e ONEDRIVE_REMOTE_DIR
echo -e "$ONEDRIVE_REMOTE_DIR\n" >> /home/pi/.config/onedrive/sync_list
chown -R pi /home/pi/.config/
onedrive --confdir /home/pi/.config/onedrive
onedrive --confdir /home/pi/.config/onedrive --synchronize --download-only
chown -R pi /home/pi/.config/
cd ..
echo "Installed"

# Finally we get to the actual setup
echo "Installing Gerald"
git clone https://github.com/TechnoElf/gerald.git
sudo sed -ie '/^exit.*/i bash \/opt\/gerald\/gerald\/start.sh &' /etc/rc.local
chmod +x /opt/gerald/gerald/display.py
chmod +x /opt/gerald/gerald/start.sh
chown -R pi /opt/gerald/
echo "Installed"

echo "Setup completed"
echo "Please reboot"
