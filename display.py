#!/usr/bin/python3

import sys, os, io, subprocess, time
from pathlib import Path

imageDisplayTime = 20
dir = "/opt/gerald/remote/"
imageExts = {".png", ".jpg"}
videoExts = {".mp4"}

def displayImages(files, delay):
	subprocess.run(["sudo", "fbi", "-d", "/dev/fb0", "-T", "1", "-a", "-t", str(delay), "--noverbose"] + files)
	time.sleep(delay * len(files))
	subprocess.run(["sudo", "pkill", "-x", "fbi"])

def displayVideos(files):
	for file in files:
		subprocess.run(["omxplayer", "--no-osd", file])

def directoryContents(path):
        files = [];
        for p in path.iterdir():
                if p.is_file():
                        files.append(p);
                else:
                        files += directoryContents(p);
        return files;


def main():
	while True:
		images = []
		videos = []
		path = Path(dir)
		for file in sorted(directoryContents(path), key=lambda f: str(f).lower()):
			if file.is_file() and file.suffix.lower() in str(imageExts):
				images.append(str(file))
			elif file.is_file() and file.suffix.lower() in str(videoExts):
				videos.append(str(file))

		displayImages(images, imageDisplayTime)
		displayVideos(videos)

if __name__ == '__main__':
	try:
		main()
	except KeyboardInterrupt:
		print('\nShutting Down...')
		subprocess.run(["sudo", "pkill", "-x", "fbi"])
		subprocess.run(["pkill", "-x", "omxplayer.bin"])
		try:
			sys.exit(0)
		except SystemExit:
			os._exit(0)
