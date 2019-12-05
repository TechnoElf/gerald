#!/usr/bin/python3
import subprocess
import sys

GERALD_PATH: str = "/opt/gerald/gerald/"


def main():
    update()
    print("Jumping...")
    subprocess.run(["python3", GERALD_PATH + "gerald.py", "&"])
    sys.exit(0)


def update():
    print("Updating gerald...")
    subprocess.run(["sudo", "git", "-C", GERALD_PATH, "pull"])
    print("Done.")


if __name__ == '__main__':
    main()
