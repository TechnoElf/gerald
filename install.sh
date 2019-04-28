#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "The installer must be run as root"
   exit 1
fi

echo "====================="
echo "Gerald Install Script"
echo "====================="
echo ""
echo "This script will take some time to install and the system may restart multiple times"
echo ""
sleep 2s

# Check if we are connected to the internet
echo "Checking for an internet connection..."
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -ne 0 ]]; then
  echo "Not connected"
  if grep -q "wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" /etc/network/interfaces; then
    echo "WiFi connection was set up already but something went wrong"
    exit 1
  else
    echo "Setting up a WiFi connection..."
    echo "SSID:"
    read -e NETWORK_SSID
    echo "Password:"
    read -e NETWORK_PASS
    echo -e "\nauto lo\niface lo inet loopback\niface eth0 inet dhcp\nallow-hotplug wlan0\nauto wlan0\niface wlan0 inet dhcp\nwpa-conf /etc/wpa_supplicant/wpa_supplicant.conf\n" >> /etc/network/interfaces
    echo -e "\nnetwork={\n    ssid=\"$NETWORK_SSID\"\n    psk=\"$NETWORK_PASS\"\n}\n" >> /etc/wpa_supplicant/wpa_supplicant.conf
    systemctl enable ssh
    systemctl start ssh
    echo "Rebooting..."
    reboot
  fi
fi
echo "Connected"

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
systemctl --user enable onedrive
systemctl --user start onedrive
onedrive --confdir /home/pi/.config/onedrive --synchronize --download-only
chown -R pi /home/pi/.config/
cd ..
echo "Installed"

# Finally we get to the actual setup
echo "Installing Gerald"
git clone https://github.com/TechnoElf/Gerald.git
sed -ie '/^#!\/bin\/bash/a bash /opt/gerald/Gerald/start.sh &' /etc/rc.local
chmod +x /opt/gerald/Gerald/dipslay.py
chmod +x /opt/gerald/Gerald/start.sh
chown -R pi /opt/gerald/
echo "Installed"

echo "Setup completed"
echo "Please reboot"

rm $0
