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
import filecmp
import shutil

def perform_backup():
    # Copies files from original location to dotfiles/...
    file_num = 1
    for file in _backup_data:
        orig_file = f'{_backup_data[file][0]}/{file}'
        backup_file = f'{_backup_data[file][1]}/{file}'
        if not os.path.exists(backup_file.replace("'", "")) or not filecmp.cmp(orig_file.replace("'", ""), backup_file.replace("'", "")):
            if not os.path.exists(_backup_data[file][1]):
                # Create the directory if it does not exist.
                os.makedirs(_backup_data[file][1], mode=0o755)
            shutil.copy(f'{_backup_data[file][0]}/{file}', _backup_data[file][1])
            print(f'{str(file_num).rjust(3)} Copied: {file} to {_backup_data[file][1]}')
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
    # Copies files from dotfiles/... to original location.
    # Is the file exists, the current file is renamed to *{_backup_file_ext}.
    file_num = 1
    for file in _backup_data:
        orig_file = f'{_backup_data[file][0]}/{file}'
        backup_file = f'{_backup_data[file][1]}/{file}'

        if os.path.exists(orig_file):
            shutil.move(orig_file, f'{orig_file}{_backup_file_ext}')
            shutil.copy(backup_file, orig_file)
            print(f'{str(file_num).rjust(3)} Restored: {file} to {_backup_data[file][0]}')
        else:
            print(f'{str(file_num).rjust(3)}  WARNING: {orig_file} does not exist, skipping...')
        file_num += 1


def perform_cleanup():
    # Removes all *{_backup_file_ext} files generated from perform_restore().
    file_num = 1
    for file in _backup_data:
        current_file = f'{_backup_data[file][0]}/{file}{_backup_file_ext}'

        if os.path.exists(current_file):
            os.remove(current_file)
            print(f'{str(file_num).rjust(3)} Removed: {current_file}')
            file_num += 1


class FileUtils:
    def sanitized_full_path(self, dir_location, file_name):
        sanitized_dir_location = dir_location
        sanitized_file_name = file_name

        if dir_location.endswith("/"):
            sanitized_dir_location = dir_location[:-1]

        if file_name.startswith("/"):
            sanitized_file_name = file_name[1:]

        return f'{sanitized_dir_location}/{sanitized_file_name}'


if __name__ == "__main__":
    _fu = FileUtils()

    _backup_dir_root = os.path.dirname(os.path.abspath(__file__))
    _backup_config_file = _fu.sanitized_full_path(_backup_dir_root, 'backupdots.json')
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
