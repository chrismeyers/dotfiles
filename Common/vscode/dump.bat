@echo off

:: Change directory to this script.
cd %~dp0

:: Dump installed extensions to file
code --list-extensions > extensions.txt
