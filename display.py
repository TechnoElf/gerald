from typing import List
import subprocess
import time

DEFAULT_DISPLAY_TIME: int = 20


def images(files: List[str]):
    subprocess.run(["sudo", "fbi", "-d", "/dev/fb0", "-T", "1", "-a", "-t", str(DEFAULT_DISPLAY_TIME), "--noverbose"] + files)
    time.sleep(DEFAULT_DISPLAY_TIME * len(files))
    subprocess.run(["sudo", "pkill", "-x", "fbi"])


def videos(files: List[str]):
    for file in files:
        subprocess.run(["omxplayer", "--no-osd", file])
