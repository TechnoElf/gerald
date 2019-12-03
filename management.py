#!/usr/bin/python3
import subprocess


def update():
    print("Updating gerald...")
    subprocess.run(["sudo", "git", "pull"])
    print("Done.")
