#!/usr/bin/env python3

"""
usage: backupdots.py [-h] [-p {macOS,Linux,Windows}] [-b] [-r] [-c] [-u]
                     [-t {print,inject}] [--check-platform]
                     [--config-file CONFIG_FILE]

Backup or restore configuration files

options:
  -h, --help            show this help message and exit
  -p, --platform {macOS,Linux,Windows}
                        overrides the current platform to determine which set of
                        files to use. WARNING: This should only be used if the
                        determined platform is wrong!
  -b, --backup          perform a backup based on files in the config file
                        (default: backupdots.json)
  -r, --restore         perform a restore based on files in the config file
                        (default: backupdots.json)
  -c, --cleanup         removes *.orig files
  -u, --unlink          removes all symlinks for the given platform
  -t, --tree {print,inject}
                        generates a directory tree and prints the output to
                        stdout or injects the output into README.md
  --check-platform      checks which platform would be run
  --config-file CONFIG_FILE
                        name of a config file to override backupdots.json
"""

import os
import sys
import platform
import json
import argparse
import shutil
import subprocess
from dataclasses import dataclass
from enum import Enum


def perform_backup():
    """Copies files to dotfiles repo and runs backup scripts"""
    file_num = 1
    for settings in _backup_data.get("files", []):
        target, source = settings[:2]

        target_dir = os.path.dirname(target)

        if not os.path.exists(source):
            Log.warn(f"Source {source} does not exist, skipping")
        elif not os.path.exists(target.replace("'", "")) and not os.path.islink(source):
            os.makedirs(target_dir, mode=0o755, exist_ok=True)

            if os.path.isdir(source):
                backup_type = "directory"
                shutil.copytree(source, target)
            else:
                backup_type = "file"
                shutil.copy(source, target)

            Log.info(
                f"Copied {backup_type}: {source} to {target}",
                gutter=LogGutter(str(file_num), 3, True),
            )
            file_num += 1

    for item in _backup_data.get("backup", []):
        name = item.get("name", "Unknown")
        script = item.get("script", None)

        if script is None:
            Log.warn(f'Missing script key for "{name}" backup entry')
            continue
        elif not os.path.exists(script):
            Log.warn(f"{script} does not exist")
            continue

        Log.info(f"Backing up {name}...", end="", flush=True)
        exit_code = os.system(script)
        if exit_code == 0:
            Log.info("done")
            file_num += 1
        else:
            Log.info(f"script exited with code {exit_code}")

    if file_num == 1:
        Log.info("Nothing to backup")


def perform_restore():
    """Symlinks files from dotfiles repo to original location"""
    file_num = 1
    for settings in _backup_data.get("files", []):
        source, target = settings[:2]
        opts = settings[2] if len(settings) > 2 else {}

        target_dir = os.path.dirname(target)

        if not os.path.exists(source):
            Log.warn(f"Source {source} does not exist, skipping")
            continue

        if not os.path.exists(target_dir):
            if opts.get("createDirs", False) == True:
                os.makedirs(target_dir, mode=0o755, exist_ok=True)
            else:
                # The createDirs option should only be enabled for items that do not have
                # their directory structure created by an external program. If an external
                # program creates the directory structure, let the program handle it and use
                # this warning as a reminder to install the program first.
                Log.warn(
                    f"Target directory {target_dir} does not exist and createDirs is not enabled, skipping"
                )
                continue

        # Make a backup of the file before creating a symlink
        if os.path.exists(target) and not os.path.islink(target):
            shutil.move(target, f"{target}.{_backup_file_ext}")

        if not os.path.exists(target):
            try:
                os.symlink(source, target)
            except PermissionError:
                if not sudo_command(f"ln -s {source} {target}"):
                    continue
            except OSError as e:
                more_info = (
                    " Try running this command as an administrator"
                    if _platform == PlatformType.WINDOWS
                    else ""
                )
                Log.warn(f"{str(e).capitalize()}.{more_info}")
                continue

            link_type = "directory" if os.path.isdir(source) else "file"
            Log.info(
                f"Linked {link_type}: {target}",
                gutter=LogGutter(str(file_num), 3, True),
            )
            file_num += 1

    if file_num == 1:
        Log.info("Nothing to restore")


def perform_cleanup():
    """Removes all *.{_backup_file_ext} files generated from restore"""
    file_num = 1
    for settings in _backup_data.get("files", []):
        _, target = settings[:2]

        current = f"{target}.{_backup_file_ext}"

        if os.path.exists(current):
            if os.path.isfile(current) or os.path.islink(current):
                cleanup_type = "symlink" if os.path.islink(current) else "file"
                try:
                    os.remove(current)
                except PermissionError:
                    if not sudo_command(f"rm {current}"):
                        continue
            elif os.path.isdir(current):
                cleanup_type = "directory"
                try:
                    shutil.rmtree(current)
                except PermissionError:
                    if not sudo_command(f"rm -rf {current}"):
                        continue
            else:
                Log.warn(f"{current} is not a file, symlink, or directory...skipping")
                continue

            Log.info(
                f"Removed {cleanup_type}: {current}",
                gutter=LogGutter(str(file_num), 3, True),
            )
            file_num += 1

    if file_num == 1:
        Log.info("Nothing to cleanup")


def perform_unlink():
    """Removes all symlinks for the given platform"""
    file_num = 1
    for settings in _backup_data.get("files", []):
        source, target = settings[:2]

        if os.path.exists(target):
            try:
                os.unlink(target)
            except PermissionError:
                if not sudo_command(f"rm {target}"):
                    continue

            Log.info(
                f'Unlinked {"directory" if os.path.isdir(source) else "file"}: {target}',
                gutter=LogGutter(str(file_num), 3, True),
            )
            file_num += 1

    if file_num == 1:
        Log.info("Nothing to unlink")


def perform_tree():
    tree_mode = (_args.tree).lower()

    tree = generate_tree()
    if tree_mode == "print":
        Log.info(tree)
    elif tree_mode == "inject":
        inject_tree(tree)


def generate_tree():
    ignored = "|".join(
        [".git", ".gitignore", ".gitmodules", "backupdots.*", "README.md"]
    )

    p = subprocess.Popen(
        f"tree -a -F --gitignore -I '{ignored}'",
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    out, err = p.communicate()

    out = out.decode("utf-8")
    err = err.decode("utf-8")

    if err != "":
        Log.error(err)
        sys.exit(1)

    out = out.replace("\\", "")

    return out


def inject_tree(tree):
    readme_path = os.path.join(_backup_dir_root, "README.md")

    if not os.path.exists(readme_path):
        Log.error(f"{readme_path} does not exist!")
        sys.exit(1)

    with open(readme_path, "r") as f_in:
        readme_lines = f_in.readlines()
        begin_index = -1
        end_index = -1

        for i, line in enumerate(readme_lines):
            if line.strip() == "<!-- BEGIN TREE -->":
                begin_index = i
            elif line.strip() == "<!-- END TREE -->":
                end_index = i

        if begin_index > 0 and end_index > 0:
            # Remove all the lines between BEGIN and END tags, then replace
            # with the new tree
            del readme_lines[begin_index + 1 : end_index]
            readme_lines.insert(begin_index + 1, f"```\n{tree}```\n")
        else:
            Log.error("BEGIN and END tags are likely missing from README.md")
            sys.exit(1)

    with open(readme_path, "w") as f_out:
        for line in readme_lines:
            f_out.write(line)

        Log.info("Updated directory tree in README.md")


def perform_check_platform():
    Log.info(f"The current platform is set to {platform_enum_to_string(_platform)}")
    if _args.platform is not None:
        actual = platform_enum_to_string(determine_platform(True))
        Log.info(
            f"NOTE: The -p/--platform flag is overriding the actual platform of {actual}"
        )


def sanitized_full_path(dir_location, file_name):
    sanitized_dir_location = dir_location
    sanitized_file_name = file_name

    if dir_location.endswith("/"):
        sanitized_dir_location = dir_location[:-1]

    if file_name.startswith("/"):
        sanitized_file_name = file_name[1:]

    return os.path.join(sanitized_dir_location, sanitized_file_name)


def sudo_command(cmd):
    success = False

    # TODO: Handle permissions error on windows
    if _platform == PlatformType.LINUX or _platform == PlatformType.MACOS:
        exit_code = os.system(f"sudo {cmd}")
        success = True if exit_code == 0 else False
    else:
        Log.warn(f"Unable to execute command `{cmd}` as a super user")

    return success


def determine_platform(force_actual=False):
    platform_enum = PlatformType.UNKNOWN

    if not force_actual:
        platform_str = (
            _args.platform if _args.platform is not None else platform.system()
        )
    else:
        platform_str = platform.system()
    platform_str = platform_str.lower().strip()

    if platform_str == "linux":
        platform_enum = PlatformType.LINUX
    elif platform_str == "macos" or platform_str == "darwin":
        platform_enum = PlatformType.MACOS
    elif platform_str == "windows":
        platform_enum = PlatformType.WINDOWS

    if platform_enum == PlatformType.UNKNOWN:
        Log.error(f'Unsupported platform "{platform_str}"')
        sys.exit(1)

    return platform_enum


def platform_enum_to_string(platform_enum):
    if platform_enum == PlatformType.LINUX:
        return "Linux"
    elif platform_enum == PlatformType.MACOS:
        return "macOS"
    elif platform_enum == PlatformType.WINDOWS:
        return "Windows"
    else:
        Log.error(f"Unsupported platform enum {repr(platform_enum)}")
        sys.exit(1)


class PlatformType(Enum):
    UNKNOWN = 0
    LINUX = 1
    MACOS = 2
    WINDOWS = 3


class LogLevel(Enum):
    INFO = 1
    WARN = 2
    ERROR = 3


@dataclass
class LogGutter:
    content: str = ""
    """The content of the gutter"""

    length: int = 0
    """
    The length of the gutter. If the length of content is less than this value,
    the gutter is aligned to this value using spaces. Otherwise, this value is
    ignored.
    """

    space: bool = False
    """Whether or not to include a space between the gutter and message"""


class Log:
    @staticmethod
    def _write(message, level=LogLevel.INFO, gutter=LogGutter(), end="\n", flush=False):
        """
        Usage examples:

        ### Simple one line message
        >>> _write("test")
        test

        ### Multi-part message on same line
        >>> _write("start...", end="", flush=True)
        >>> _write("end")
        start...end

        ### Default level message with a gutter using positional args
        >>> _write("test", gutter=LogGutter("1", 3, True))
        1 test

        ### Elevated level message with a gutter using kwargs
        >>> _write("test", level=LogLevel.WARN, gutter=LogGutter(content="1", length=3, space=True))
        1 WARNING: test

        ### Gutter with one argument using kwargs
        >>> _write("test", gutter=LogGutter(length=4))
            test
        """

        level_prefix = (
            "ERROR: "
            if level == LogLevel.ERROR
            else "WARNING: " if level == LogLevel.WARN else ""
        )

        print(
            f'{str(gutter.content).rjust(gutter.length)}{" " if gutter.space else ""}{level_prefix}{message}',
            end=end,
            flush=flush,
        )

    @staticmethod
    def info(message, gutter=LogGutter(), end="\n", flush=False):
        Log._write(message, level=LogLevel.INFO, gutter=gutter, end=end, flush=flush)

    @staticmethod
    def warn(message, gutter=LogGutter(), end="\n", flush=False):
        Log._write(message, level=LogLevel.WARN, gutter=gutter, end=end, flush=flush)

    @staticmethod
    def error(message, gutter=LogGutter(), end="\n", flush=False):
        Log._write(message, level=LogLevel.ERROR, gutter=gutter, end=end, flush=flush)


if __name__ == "__main__":
    if sys.version_info < (3, 7, 0):
        Log.error("This script requires Python >= 3.7.0")
        sys.exit(1)

    _backup_dir_root = os.path.dirname(os.path.abspath(__file__))
    _backup_config_file = sanitized_full_path(_backup_dir_root, "backupdots.json")
    _backup_file_ext = "orig"
    _tree_modes = ["print", "inject"]
    _platforms = ["macOS", "Linux", "Windows"]
    _platform = PlatformType.UNKNOWN

    arg_parser = argparse.ArgumentParser(
        description="Backup or restore configuration files",
        formatter_class=lambda prog: argparse.HelpFormatter(prog, width=80),
    )

    arg_parser.add_argument(
        "-p",
        "--platform",
        help="overrides the current platform to determine which set of files to use. "
        "WARNING: This should only be used if the determined platform is wrong!",
        choices=_platforms,
    )

    arg_parser.add_argument(
        "-b",
        "--backup",
        help="perform a backup based on files in the config file (default: backupdots.json)",
        action="store_true",
    )

    arg_parser.add_argument(
        "-r",
        "--restore",
        help="perform a restore based on files in the config file (default: backupdots.json)",
        action="store_true",
    )

    arg_parser.add_argument(
        "-c",
        "--cleanup",
        help=f"removes *.{_backup_file_ext} files",
        action="store_true",
    )

    arg_parser.add_argument(
        "-u",
        "--unlink",
        help="removes all symlinks for the given platform",
        action="store_true",
    )

    arg_parser.add_argument(
        "-t",
        "--tree",
        help="generates a directory tree and prints the output to stdout or injects the output into README.md",
        choices=_tree_modes,
        type=str.lower,
    )

    arg_parser.add_argument(
        "--check-platform",
        help="checks which platform would be run",
        action="store_true",
    )

    arg_parser.add_argument(
        "--config-file", help="name of a config file to override backupdots.json"
    )

    _args = arg_parser.parse_args()

    if _args.config_file:
        _backup_config_file = sanitized_full_path(_backup_dir_root, _args.config_file)

    if not os.path.exists(_backup_config_file):
        Log.error(f'Configuration file "{_backup_config_file}" does not exist')
        sys.exit(1)

    with open(_backup_config_file) as f:
        _all_backup_data = json.load(f)

    _platform = determine_platform()
    try:
        _backup_data = _all_backup_data[platform_enum_to_string(_platform)]
    except KeyError:
        Log.error(
            f'Configuration file "{_backup_config_file}" does not contain platform {platform_enum_to_string(_platform)}'
        )
        sys.exit(1)

    if _args.backup:
        perform_backup()
    elif _args.restore:
        perform_restore()
    elif _args.cleanup:
        perform_cleanup()
    elif _args.unlink:
        perform_unlink()
    elif _args.tree:
        perform_tree()
    elif _args.check_platform:
        perform_check_platform()
    else:
        perform_backup()
