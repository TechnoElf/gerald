#!/usr/bin/python3
import sys
import subprocess

import parser
import remote
import management
import display

IMAGE_DISPLAY_TIME = 20


def main():
    management.update()
    remote.sync_onedrive()

    while True:
        files = parser.parse_file_list(remote.directory_contents())

        display.images(filter((lambda file_and_type: (file_and_type[1] == parser.FileType.IMAGE)), files), IMAGE_DISPLAY_TIME)
        display.videos(filter((lambda file_and_type: (file_and_type[1] == parser.FileType.VIDEO)), files))


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\nShutting Down...')
        subprocess.run(["sudo", "pkill", "-x", "fbi"])
        subprocess.run(["pkill", "-x", "omxplayer.bin"])
        sys.exit(0)
