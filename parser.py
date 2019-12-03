#!/usr/bin/python3
from enum import Enum, auto

IMAGE_EXTENSIONS = {".png", ".jpg", ".bmp", ".gif"}
VIDEO_EXTENSIONS = {".mp4", ".mov"}


class FileType(Enum):
    NONE = auto()
    IMAGE = auto()
    VIDEO = auto()


def parse_file_list(files):
    typed_files = list(map((lambda file: (file, file_type(file))), files))
    return filter((lambda file_and_type: (file_and_type[1] != FileType.NONE)), typed_files)


def file_type(file):
    if file.suffix.lower() in IMAGE_EXTENSIONS:
        return FileType.IMAGE
    elif file.suffix.lower() in VIDEO_EXTENSIONS:
        return FileType.VIDEO
    else:
        return FileType.NONE
