#!/usr/bin/env python3

'''
usage: backupdots.py [-h] [-b] [-r] [-c]

Backup or restore configuration files.

optional arguments:
  -h, --help     show this help message and exit
  -b, --backup   perform a backup based on files in backupdots.json
  -r, --restore  perform a restore based on files in backupdots.json
  -c, --cleanup  removes *.orig files
'''

import os
import sys
import json
import argparse
import filecmp

def perform_backup():
    # Copies files from original location to dotfiles/...
    file_num = 1
    for file in _backup_data:
        orig_file = f'{_backup_data[file][0]}/{file}'
        backup_file = f'{_backup_data[file][1]}/{file}'
        if not os.path.exists(backup_file.replace("'", "")) or not filecmp.cmp(orig_file.replace("'", ""), backup_file.replace("'", "")):
            if not os.path.exists(_backup_data[file][1]):
                # Create the directory if it does not exist.
                os.system(f'mkdir -p {_backup_data[file][1]}')
            os.system(f'cp {_backup_data[file][0]}/{file} {_backup_data[file][1]}')
            print(f'{str(file_num).rjust(3)} Copied: {file} to {_backup_data[file][1]}')
            file_num += 1

    os.system(f'{_backup_dir_root}/Homebrew/dump.sh')
    print('Updated brew bundle dump...')


def perform_restore():
    # Copies files from dotfiles/... to original location.
    # Is the file exists, the current file is renamed to *{_backup_file_ext}.
    file_num = 1
    for file in _backup_data:
        orig_file = f'{_backup_data[file][0]}/{file}'
        backup_file = f'{_backup_data[file][1]}/{file}'

        if os.path.exists(orig_file.replace("'", "")):
            os.system(f'mv {orig_file} {orig_file}{_backup_file_ext}')

        os.system(f'cp {backup_file} {orig_file}')
        print(f'{str(file_num).rjust(3)} Restored: {file} to {_backup_data[file][0]}')
        file_num += 1


def perform_cleanup():
    # Removes all *{_backup_file_ext} files generated from perform_restore().
    file_num = 1
    for file in _backup_data:
        current_file = handle_files_with_spaces(f'{_backup_data[file][0]}/{file}')

        if os.path.exists(current_file.replace("'", "")):
            os.system(f'rm -f {current_file}')
            print(f'{str(file_num).rjust(3)} Removed: {current_file}')
            file_num += 1


def handle_files_with_spaces(file_name):
    if file_name.endswith("'"):
        return f'{file_name[:-1]}{_backup_file_ext}\''
    else:
        return f'{file_name}{_backup_file_ext}'


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
    arg_parser.add_argument('-b', '--backup', help='perform a backup based on files in backupdots.json', action='store_true')
    arg_parser.add_argument('-r', '--restore', help='perform a restore based on files in backupdots.json', action='store_true')
    arg_parser.add_argument('-c', '--cleanup', help=f'removes *{_backup_file_ext} files', action='store_true')
    _args = arg_parser.parse_args()

    if not os.path.exists(_backup_config_file):
        print(f'ERROR: Configuration file "{_backup_config_file}" does not exist.')
        sys.exit(1)

    with open(_backup_config_file) as f:
        _backup_data = json.load(f)

    if _args.backup:
        perform_backup()
    elif _args.restore:
        perform_restore()
    elif _args.cleanup:
        perform_cleanup()
    else:
        perform_backup()
