#!/bin/bash
if ! pgrep -x "display.py" > /dev/null
then
	echo "Syncing..."
	onedrive --synchronize --confdir /home/pi/.config/onedrive
	echo "Done."
	python3 /opt/gerald/Gerald/display.py
else
	pkill -x "display.py"
	sudo pkill -x "fbi"
	pkill -x "omxplayer.bin"
	echo "---------------------------------------------"
	echo "Welcome to Gerald, the digital signage system"
	echo "---------------------------------------------"
fi
