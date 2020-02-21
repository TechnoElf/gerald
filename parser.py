from typing import List, Set, Dict
from enum import Enum
from pathlib import Path
import re


IMAGE_EXTENSIONS: Set[str] = {".png", ".jpg", ".bmp", ".gif"}
VIDEO_EXTENSIONS: Set[str] = {".mp4", ".mov"}


class FileType(Enum):
    NONE = 1
    IMAGE = 2
    VIDEO = 3


class FileData:
    def __init__(self, path: Path, type: FileType):
        self.path = path
        self.type = type
        self.disp_time = 10


def parse_file_list(files: List[Path]) -> List[FileData]:
    typed_files = list(map((lambda file: (file, file_type(file))), files))
    filtered_files = filter((lambda file_and_type: (file_and_type[1] != FileType.NONE)), typed_files)
    return list(map((lambda file_and_type: parse_file_name(file_and_type[0], file_and_type[1])), filtered_files))


def file_type(file: Path) -> FileType:
    if file.suffix.lower() in IMAGE_EXTENSIONS:
        return FileType.IMAGE
    elif file.suffix.lower() in VIDEO_EXTENSIONS:
        return FileType.VIDEO
    else:
        return FileType.NONE


def parse_file_name(path: Path, type: FileType) -> FileData:
    data: FileData = FileData(path, type)

    parameters_maybe: List[str] = re.compile("{.*?}", flags = re.DOTALL).findall(path.stem)
    if len(parameters_maybe) != 1:
        return data

    parameters_str: str = parameters_maybe[0].partition("{")[2].partition("}")[0].replace(" ", "")
    parameters: Dict[str] = dict((parameter.partition("=")[0], parameter.partition("=")[2]) for parameter in parameters_str.split(";"))
    if "disp_time" in parameters:
        data.disp_time = int(parameters["disp_time"])

    return data
