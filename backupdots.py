#!/usr/bin/env python3

'''
usage: backupdots.py [-h] [-p {Mac,Linux,Windows}] [-b] [-r] [-c] [-u]
                     [-t {print,inject}] [--check-platform]
                     [--config-file CONFIG_FILE]

Backup or restore configuration files.

optional arguments:
  -h, --help            show this help message and exit
  -p {Mac,Linux,Windows}, --platform {Mac,Linux,Windows}
                        overrides the current platform to determine which set
                        of files to use. WARNING: This should only be used if
                        the determined platform is wrong!
  -b, --backup          perform a backup based on files in the config file
                        (default: backupdots.json)
  -r, --restore         perform a restore based on files in the config file
                        (default: backupdots.json)
  -c, --cleanup         removes *.orig files
  -u, --unlink          removes all symlinks for the given platform
  -t {print,inject}, --tree {print,inject}
                        generates a directory tree and prints the output to
                        stdout or injects the output into README.md
  --check-platform      checks which platform would be run
  --config-file CONFIG_FILE
                        name of a config file to override backupdots.json
'''

import os
import sys
import platform
import json
import argparse
import shutil
import subprocess
from enum import Enum


def perform_backup():
    # Copies files from original location to dotfiles/...
    file_num = 1
    for file in _backup_data:
        orig_file = os.path.join(_backup_data[file][0], file)
        backup_file = os.path.join(_backup_data[file][1], file)

        if not os.path.exists(backup_file.replace("'", "")) and not os.path.islink(orig_file):
            if not os.path.exists(_backup_data[file][1]):
                os.makedirs(_backup_data[file][1], mode=0o755)
            if not os.path.isdir(orig_file):
                backup_type = 'file'
                shutil.copy(os.path.join(_backup_data[file][0], file), _backup_data[file][1])
            else:
                backup_type = 'directory'
                shutil.copytree(os.path.join(_backup_data[file][0], file), os.path.join(_backup_data[file][1], file))
            print(f'{str(file_num).rjust(3)} Copied {backup_type}: {file} to {_backup_data[file][1]}')
            file_num += 1

    if file_num == 1:
        print('Nothing to backup.')


    if _backup_scripts is not None:
        for item in _backup_scripts:
            name = item.get('name', 'Unknown')
            script = item.get("script", None)

            if script is None:
                print(f'WARNING: Missing script key for "{name}" {_backup_config_key} entry')
                continue
            elif not os.path.exists(script):
                print(f'WARNING: {script} does not exist')
                continue

            print(f'Dumping {name}...', end='', flush=True)
            exit_code = os.system(script)
            if exit_code == 0:
                print('complete.')
            else:
                print(f'script exited with code {exit_code}.')


def perform_restore():
    # Symlinks files from dotfiles/... to original location.
    file_num = 1
    for file in _backup_data:
        orig_file = os.path.join(_backup_data[file][0], file)
        backup_file = os.path.join(_backup_data[file][1], file)

        # Assume that the program isn't installed or the configuration file is
        # not needed if the original path doesn't exist.
        if os.path.exists(_backup_data[file][0]):
            # Make a backup of the file before creating a symlink.
            if os.path.exists(orig_file) and not os.path.islink(orig_file):
                shutil.move(orig_file, f'{orig_file}.{_backup_file_ext}')
            if not os.path.exists(orig_file):
                try:
                    os.symlink(backup_file, orig_file)
                except PermissionError:
                    if not sudo_command(f'ln -s {backup_file} {orig_file}'):
                        continue
                except OSError as e:
                    more_info = ' Try running this command as an administrator.' if _platform == PlatformType.WINDOWS else ''
                    print(f'{"".rjust(4)}WARNING: {str(e).capitalize()}.{more_info}')
                    continue

                link_type = 'directory' if os.path.isdir(backup_file) else 'file'
                print(f'{str(file_num).rjust(3)} Linked {link_type}: {file} to {_backup_data[file][0]}')
                file_num += 1
        else:
            print(f'{"".rjust(4)}WARNING: {_backup_data[file][0]} does not exist, skipping.')

    if file_num == 1:
        print('Nothing to restore.')


def perform_cleanup():
    # Removes all *.{_backup_file_ext} files generated from perform_restore().
    file_num = 1
    for file in _backup_data:
        current_file = os.path.join(_backup_data[file][0], f'{file}.{_backup_file_ext}')

        if os.path.exists(current_file):
            if os.path.isfile(current_file) or os.path.islink(current_file):
                cleanup_type = 'file' if os.path.isfile(current_file) else 'symlink'
                try:
                    os.remove(current_file)
                except PermissionError:
                    if not sudo_command(f'rm {current_file}'):
                        continue
            elif os.path.isdir(current_file):
                cleanup_type = 'directory'
                try:
                    shutil.rmtree(current_file)
                except PermissionError:
                    if not sudo_command(f'rm -rf {current_file}'):
                        continue
            else:
                print(f'{"".rjust(4)}WARNING: {current_file} is not a file, symlink, or directory. Skipping.')
                continue

            print(f'{str(file_num).rjust(3)} Removed {cleanup_type}: {current_file}')
            file_num += 1

    if file_num == 1:
        print('Nothing to cleanup.')


def perform_unlink():
    # Removes all symlinks for the given platform.
    file_num = 1
    for file in _backup_data:
        is_dir = os.path.isdir(os.path.join(_backup_data[file][1], file))
        current_file = os.path.join(_backup_data[file][0], file)

        if os.path.exists(current_file):
            try:
                os.unlink(current_file)
            except PermissionError:
                if not sudo_command(f'rm {current_file}'):
                    continue
            print(f'{str(file_num).rjust(3)} Unlinked {"directory" if is_dir else "file"}: {current_file}')
            file_num += 1

    if file_num == 1:
        print('Nothing to unlink.')


def perform_tree():
    tree_mode = (_args.tree).lower()

    tree = generate_tree()
    if tree_mode == 'print':
        print(tree)
    elif tree_mode == 'inject':
        inject_tree(tree)


def generate_tree():
    # NOTE: I only want the names of Vim plugins to appear in the tree. In
    # order to skip all the files in each Vim plugin dir, a maximum tree
    # depth has been set. That being said, config files shouldn't be nested
    # greater than this depth!
    # TODO: There may be a better way to do this, but I can't figure out a
    # way to ignore files/dirs under certain directories through the tree
    # command. If the max depth ever becomes an issue, parsing the output
    # from the tree command (use JSON output flag?) or drawing a custom tree
    # may be needed.
    gitignored = []
    gitignore_path = f'{_backup_dir_root}/.gitignore'
    if os.path.exists(gitignore_path):
        with open(gitignore_path, 'r') as f:
            gitignored = [x.strip() for x in f.readlines()]

    max_tree_depth = 7
    ignored = '|'.join(['.git', '.gitignore', '.gitmodules', 'backupdots.*',
                        'README.md', *gitignored])

    p = subprocess.Popen(f"tree -a -F -I '{ignored}' -L {max_tree_depth}",
                         shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()

    out = out.decode('utf-8')
    err = err.decode('utf-8')

    if err != '':
        print(f'ERROR: {err}')
        sys.exit(1)

    out = out.replace('\\', '')

    return out


def inject_tree(tree):
    readme_path = os.path.join(_backup_dir_root, 'README.md')

    if not os.path.exists(readme_path):
        print(f'ERROR: {readme_path} does not exist!')
        sys.exit(1)

    with open(readme_path, 'r') as f_in:
        readme_lines = f_in.readlines()
        begin_index = -1
        end_index = -1

        for i, line in enumerate(readme_lines):
            if line.strip() == '<!-- BEGIN TREE -->':
                begin_index = i
            elif line.strip() == '<!-- END TREE -->':
                end_index = i

        if begin_index > 0 and end_index > 0:
            # Remove all the lines between BEGIN and END tags, then replace
            # with the new tree.
            del readme_lines[begin_index + 1:end_index]
            readme_lines.insert(begin_index + 1, f'```\n{tree}```\n')
        else:
            print('ERROR: BEGIN and END tags are likely missing from README.md')
            sys.exit(1)

    with open(readme_path, 'w') as f_out:
        for line in readme_lines:
            f_out.write(line)

        print('Updated directory tree in README.md.')


def perform_check_platform():
    print(f'The current platform is set to {platform_enum_to_string(_platform)}.')
    if _args.platform is not None:
        actual = platform_enum_to_string(determine_platform(True))
        print(f'NOTE: The -p/--platform flag is overriding the actual platform of {actual}.')


def sanitized_full_path(dir_location, file_name):
    sanitized_dir_location = dir_location
    sanitized_file_name = file_name

    if dir_location.endswith('/'):
        sanitized_dir_location = dir_location[:-1]

    if file_name.startswith('/'):
        sanitized_file_name = file_name[1:]

    return os.path.join(sanitized_dir_location, sanitized_file_name)


def sudo_command(cmd):
    success = False

    # TODO: Handle permissions error on windows
    if _platform == PlatformType.LINUX or _platform == PlatformType.MAC:
        exit_code = os.system(f'sudo {cmd}')
        success = True if exit_code == 0 else False
    else:
        print(f'{"".rjust(4)}WARNING: Unable to execute command `{cmd}` as a super user.')

    return success


def determine_platform(force_actual=False):
    platform_enum = PlatformType.UNKNOWN

    if not force_actual:
        platform_str = _args.platform if _args.platform is not None else platform.system()
    else:
        platform_str = platform.system()
    platform_str = platform_str.lower().strip()

    if platform_str == 'linux':
        platform_enum = PlatformType.LINUX
    elif platform_str == 'mac' or platform_str == 'darwin':
        platform_enum = PlatformType.MAC
    elif platform_str == "windows":
        platform_enum = PlatformType.WINDOWS

    if platform_enum == PlatformType.UNKNOWN:
        print(f'ERROR: Unsupported platform "{platform_str}"')
        sys.exit(1)

    return platform_enum


def platform_enum_to_string(platform_enum):
    if platform_enum == PlatformType.LINUX:
        return 'Linux'
    elif platform_enum == PlatformType.MAC:
        return 'Mac'
    elif platform_enum == PlatformType.WINDOWS:
        return 'Windows'
    else:
        print(f'Unsupported platform enum {repr(platform_enum)}')
        sys.exit(1)


class PlatformType(Enum):
    UNKNOWN = 0
    LINUX = 1
    MAC = 2
    WINDOWS = 3


if __name__ == '__main__':
    _backup_dir_root = os.path.dirname(os.path.abspath(__file__))
    _backup_config_file = sanitized_full_path(_backup_dir_root, 'backupdots.json')
    _backup_file_ext = 'orig'
    _tree_modes = ['print', 'inject']
    _platforms = ['Mac', 'Linux', 'Windows']
    _platform = PlatformType.UNKNOWN
    _backup_config_key = '__backup__'
    _backup_scripts = None

    arg_parser = argparse.ArgumentParser(
        description='Backup or restore configuration files.')

    arg_parser.add_argument(
        '-p', '--platform',
        help='overrides the current platform to determine which set of files to use. '
        'WARNING: This should only be used if the determined platform is wrong!',
        choices=_platforms,
        type=str.capitalize)

    arg_parser.add_argument(
        '-b', '--backup',
        help='perform a backup based on files in the config file (default: backupdots.json)',
        action='store_true')

    arg_parser.add_argument(
        '-r', '--restore',
        help='perform a restore based on files in the config file (default: backupdots.json)',
        action='store_true')

    arg_parser.add_argument(
        '-c', '--cleanup',
        help=f'removes *.{_backup_file_ext} files',
        action='store_true')

    arg_parser.add_argument(
        '-u', '--unlink',
        help='removes all symlinks for the given platform',
        action='store_true')

    arg_parser.add_argument(
        '-t', '--tree',
        help=f'generates a directory tree and prints the output to stdout or injects the '
        'output into README.md',
        choices=_tree_modes,
        type=str.lower)

    arg_parser.add_argument(
        '--check-platform',
        help='checks which platform would be run',
        action='store_true')

    arg_parser.add_argument(
        '--config-file',
        help='name of a config file to override backupdots.json')

    _args = arg_parser.parse_args()

    if _args.config_file:
        _backup_config_file = sanitized_full_path(_backup_dir_root, _args.config_file)

    if not os.path.exists(_backup_config_file):
        print(f'ERROR: Configuration file "{_backup_config_file}" does not exist.')
        sys.exit(1)

    with open(_backup_config_file) as f:
        _all_backup_data = json.load(f)

    _platform = determine_platform()
    try:
        _backup_data = _all_backup_data[platform_enum_to_string(_platform)]
        # Extract backup scripts so they don't interfere with normal processing
        _backup_scripts = _backup_data.pop(_backup_config_key, None)
    except KeyError:
        print(f'ERROR: Configuration file "{_backup_config_file}" does not contain platform {platform_enum_to_string(_platform)}.')
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
