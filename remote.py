#!/usr/bin/python3
import subprocess


def sync_onedrive():
    subprocess.run(["onedrive", "--synchronize", "--download-only", "--confdir", "/home/pi/.config/onedrive"])


def directory_contents(directory_path):
    files = []
    for path in directory_path.iterdir():
        if path.is_file():
            files.append(path)
        else:
            files += directory_contents(path)
    return files
