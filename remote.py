from typing import List
import subprocess
from pathlib import Path

GERALD_ROOT_DIRECTORY: str = "/opt/gerald"
REMOTE_DIRECTORY: str = GERALD_ROOT_DIRECTORY + "/remote"
ONEDRIVE_CONFIG: str = GERALD_ROOT_DIRECTORY + "/config/onedrive"
ONEDRIVE_LOCATION: str = GERALD_ROOT_DIRECTORY + "/onedrive"


def synchronise():
    sync_onedrive()


def sync_onedrive():
    print("Syncing OneDrive remote...")
    subprocess.run(["sudo", "rm", "-rf", REMOTE_DIRECTORY + "/*"])
    subprocess.run(["sudo", "rm", "-f", ONEDRIVE_CONFIG + "/items.sqlite3"])
    subprocess.run([ONEDRIVE_LOCATION, "--synchronize", "--download-only", "--confdir", ONEDRIVE_CONFIG])
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
