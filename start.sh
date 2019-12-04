#!/bin/bash
if ! pgrep -x "gerald.py" > /dev/null
then
	  python3 /opt/gerald/gerald/trampoline.py
fi
