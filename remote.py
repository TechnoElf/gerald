import subprocess
from pathlib import Path

REMOTE_DIRECTORY = "/opt/gerald/remote/"


def synchronise():
    sync_onedrive()


def sync_onedrive():
    print("Syncing OneDrive remote...")
    subprocess.run(["onedrive", "--synchronize", "--download-only", "--confdir", "/home/pi/.config/onedrive"])
    print("Done.")


def get_content():
    return crawl_directory(Path(REMOTE_DIRECTORY))


def crawl_directory(dir_path):
    files = []
    for path in dir_path.iterdir():
        if path.is_file():
            files.append(path)
        else:
            files += crawl_directory(path)
    return files
