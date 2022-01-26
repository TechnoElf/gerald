#!/bin/bash

INSTALL_TARGET_ROOT="/opt/gerald/"
ONEDRIVE_CONFIG="${INSTALL_TARGET_ROOT}/config/onedrive/"

# Configure the OneDrive client - this should (can realistically only) be done via ssh
onedrive --confdir $ONEDRIVE_CONFIG
onedrive --confdir $ONEDRIVE_CONFIG --synchronize --download-only

# Start gerald automatically
sudo sed -ie '/^exit.*/i bash \/opt\/gerald\/gerald\/start.sh &' /etc/rc.local
chmod +x ${INSTALL_TARGET_ROOT}/gerald/start.sh
