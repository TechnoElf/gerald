#!/bin/bash
ifconfig
if ! pgrep -x "display.py" > /dev/null
then
	echo "Syncing..."
	onedrive
	echo "Done."
	~/Display/display.py
else
	pkill -x "display.py"
	sudo pkill -x "fbi"
	pkill -x "omxplayer.bin"
	echo "---------------------------------------------"
	echo "Welcome to Gerald, the digital signage system"
	echo "---------------------------------------------"
fi
