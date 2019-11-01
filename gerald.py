#!/usr/bin/python3
import sys
import subprocess
from pathlib import Path

import remote
import management
import display

IMAGE_DISPLAY_TIME = 20
REMOTE_DIRECTORY = "/opt/gerald/remote/"
IMAGE_EXTENSIONS = {".png", ".jpg", ".bmp", ".gif"}
VIDEO_EXTENSION = {".mp4", ".mov"}


def main():
    management.update()
    remote.sync_onedrive()

    while True:
        images = []
        videos = []
        path = Path(REMOTE_DIRECTORY)
        for file in sorted(remote.directory_contents(path), key=lambda f: str(f).lower()):
            if file.is_file() and file.suffix.lower() in str(IMAGE_EXTENSIONS):
                images.append(str(file))
            elif file.is_file() and file.suffix.lower() in str(VIDEO_EXTENSION):
                videos.append(str(file))

        display.images(images, IMAGE_DISPLAY_TIME)
        display.videos(videos)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\nShutting Down...')
        subprocess.run(["sudo", "pkill", "-x", "fbi"])
        subprocess.run(["pkill", "-x", "omxplayer.bin"])
        sys.exit(0)
