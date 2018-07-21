#!/usr/bin/env python3

'''
usage: backupdots.py [-h] -p PLATFORM [-b] [-r] [-c]

Backup or restore configuration files.

optional arguments:
  -h, --help            show this help message and exit
  -p PLATFORM, --platform PLATFORM
                        specifies which set of files to use (Mac, Linux,
                        Windows)
  -b, --backup          perform a backup based on files in backupdots.json
  -r, --restore         perform a restore based on files in backupdots.json
  -c, --cleanup         removes *.orig files
'''

import os
import sys
import json
import argparse
import shutil

def perform_backup():
    # Copies files from original location to dotfiles/...
    file_num = 1
    for file in _backup_data:
        orig_file = f'{_backup_data[file][0]}/{file}'
        backup_file = f'{_backup_data[file][1]}/{file}'

        if not os.path.exists(backup_file.replace("'", "")) and not os.path.islink(orig_file):
            if not os.path.exists(_backup_data[file][1]):
                os.makedirs(_backup_data[file][1], mode=0o755)
            if not os.path.isdir(orig_file):
                backup_type = "file"
                shutil.copy(f'{_backup_data[file][0]}/{file}', _backup_data[file][1])
            else:
                backup_type = "directory"
                shutil.copytree(f'{_backup_data[file][0]}/{file}', f'{_backup_data[file][1]}/{file}')
            print(f'{str(file_num).rjust(3)} Copied {backup_type}: {file} to {_backup_data[file][1]}')
            file_num += 1

    if file_num == 1:
        print("Nothing to backup...")

    if (_args.platform).lower() == "mac":
        print('Dumping installed homebrew packages...')
        os.system(f'{_backup_dir_root}/Mac/Homebrew/dump.sh')
        print('...brew bundle dump complete!')

    if (_args.platform).lower() == "linux":
        print('Dumping GNOME Terminal default profile...')
        os.system(f'{_backup_dir_root}/Linux/GNOMETerminal/dump.sh')
        print('...profile dump complete!')

def perform_restore():
    # Symlinks files from dotfiles/... to original location.
    file_num = 1
    for file in _backup_data:
        orig_file = f'{_backup_data[file][0]}/{file}'
        backup_file = f'{_backup_data[file][1]}/{file}'

        # Assume that the program isn't installed or the configuration file is
        # not needed if the original path doesn't exist.
        if os.path.exists(_backup_data[file][0]):
            # Make a backup of the file before creating a symlink.
            if os.path.exists(orig_file) and not os.path.islink(orig_file):
                shutil.move(orig_file, f'{orig_file}{_backup_file_ext}')
            if not os.path.exists(orig_file):
                os.symlink(backup_file, orig_file)
                print(f'{str(file_num).rjust(3)} Linked: {file} to {_backup_data[file][0]}')
                file_num += 1
        else:
            print(f'{str(file_num).rjust(3)}  WARNING: {_backup_data[file][0]} does not exist, skipping...')

    if file_num == 1:
        print("Nothing to restore...")


def perform_cleanup():
    # Removes all *{_backup_file_ext} files generated from perform_restore().
    file_num = 1
    for file in _backup_data:
        current_file = f'{_backup_data[file][0]}/{file}{_backup_file_ext}'

        if os.path.exists(current_file):
            if not os.path.isdir(current_file):
                cleanup_type = "file"
                os.remove(current_file)
            else:
                cleanup_type = "directory"
                shutil.rmtree(current_file)
            print(f'{str(file_num).rjust(3)} Removed {cleanup_type}: {current_file}')
            file_num += 1

    if file_num == 1:
        print("Nothing to cleanup...")

def sanitized_full_path(dir_location, file_name):
    sanitized_dir_location = dir_location
    sanitized_file_name = file_name

    if dir_location.endswith("/"):
        sanitized_dir_location = dir_location[:-1]

    if file_name.startswith("/"):
        sanitized_file_name = file_name[1:]

    return f'{sanitized_dir_location}/{sanitized_file_name}'


if __name__ == "__main__":
    _backup_dir_root = os.path.dirname(os.path.abspath(__file__))
    _backup_config_file = sanitized_full_path(_backup_dir_root, 'backupdots.json')
    _backup_file_ext = ".orig"

    arg_parser = argparse.ArgumentParser(description='Backup or restore configuration files.')
    arg_parser.add_argument('-p', '--platform', help='specifies which set of files to use (Mac, Linux, Windows)', required=True)
    arg_parser.add_argument('-b', '--backup', help='perform a backup based on files in backupdots.json', action='store_true')
    arg_parser.add_argument('-r', '--restore', help='perform a restore based on files in backupdots.json', action='store_true')
    arg_parser.add_argument('-c', '--cleanup', help=f'removes *{_backup_file_ext} files', action='store_true')
    _args = arg_parser.parse_args()

    if not os.path.exists(_backup_config_file):
        print(f'ERROR: Configuration file "{_backup_config_file}" does not exist.')
        sys.exit(1)

    with open(_backup_config_file) as f:
        _backup_data = json.load(f)[(_args.platform).capitalize()]

    if _args.backup:
        perform_backup()
    elif _args.restore:
        perform_restore()
    elif _args.cleanup:
        perform_cleanup()
    else:
        perform_backup()
