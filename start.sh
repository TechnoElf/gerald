#!/bin/bash
if ! pgrep -x "display.py" > /dev/null
then
	echo "Updating..."
	mv /opt/gerald/gerald/update.sh /opt/gerald/update.sh
	chmod +x /opt/gerald/update.sh
	bash /opt/gerald/update.sh
	rm /opt/gerald/update.sh
	echo "Syncing..."
	onedrive --synchronize --download-only --confdir /home/pi/.config/onedrive
	echo "Done."
	python3 /opt/gerald/gerald/display.py
else
	pkill -x "display.py"
	sudo pkill -x "fbi"
	pkill -x "omxplayer.bin"
	echo "---------------------------------------------"
	echo "Welcome to Gerald, the digital signage system"
	echo "---------------------------------------------"
fi
