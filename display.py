from typing import List
import subprocess
import time

import parser

DEFAULT_DISPLAY_TIME: int = 20


def image(image: parser.FileData):
    subprocess.run(["sudo", "fbi", "-d", "/dev/fb0", "-T", "1", "-a", "-t", str(image.disp_time), "--noverbose", str(image.path)])
    time.sleep(image.disp_time)
    subprocess.run(["sudo", "pkill", "-x", "fbi"])


def video(video: parser.FileData):
    subprocess.run(["omxplayer", "--no-osd", str(video.path)])


def images(files: List[str]):
    subprocess.run(["sudo", "fbi", "-d", "/dev/fb0", "-T", "1", "-a", "-t", str(DEFAULT_DISPLAY_TIME), "--noverbose"] + files)
    time.sleep(DEFAULT_DISPLAY_TIME * len(files))
    subprocess.run(["sudo", "pkill", "-x", "fbi"])


def videos(files: List[str]):
    for file in files:
        subprocess.run(["omxplayer", "--no-osd", file])
