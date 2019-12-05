from typing import List
import subprocess
from pathlib import Path

REMOTE_DIRECTORY: str = "/opt/gerald/remote/"


def synchronise():
    sync_onedrive()


def sync_onedrive():
    print("Syncing OneDrive remote...")
    subprocess.run(["sudo", "rm", "-rf", REMOTE_DIRECTORY + "/*"])
    subprocess.run(["sudo", "rm", "-f", "/home/pi/.config/onedrive/items.sqlite3"])
    subprocess.run(["onedrive", "--synchronize", "--download-only", "--confdir", "/home/pi/.config/onedrive"])
    print("Done.")


def get_content() -> List[Path]:
    return crawl_directory(Path(REMOTE_DIRECTORY))


def crawl_directory(dir_path) -> List[Path]:
    files = []
    for path in dir_path.iterdir():
        if path.is_file():
            files.append(path)
        else:
            files += crawl_directory(path)
    return files
