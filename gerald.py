#!/usr/bin/python3
import sys
import subprocess
import time

import parser
import remote
import display


def main():
    remote.synchronise()
    files = parser.parse_file_list(remote.get_content())

    while len(files) == 0:
        print("No files found, retrying...")
        remote.synchronise()
        files = parser.parse_file_list(remote.get_content())
        time.sleep(20)

    while True:
        display.images(list(map((lambda file: str(file.path)), filter((lambda file: (file.type == parser.FileType.IMAGE)), files))))
        display.videos(list(map((lambda file: str(file.path)), filter((lambda file: (file.type == parser.FileType.VIDEO)), files))))


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\nShutting Down...')
        subprocess.run(["sudo", "pkill", "-x", "fbi"])
        subprocess.run(["pkill", "-x", "omxplayer.bin"])
        sys.exit(0)
