import subprocess
import time


def images(files, delay):
    subprocess.run(["sudo", "fbi", "-d", "/dev/fb0", "-T", "1", "-a", "-t", str(delay), "--noverbose"] + files)
    time.sleep(delay * len(files))
    subprocess.run(["sudo", "pkill", "-x", "fbi"])


def videos(files):
    for file in files:
        subprocess.run(["omxplayer", "--no-osd", file])
