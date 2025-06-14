@echo off

:: Change directory to this script.
cd %~dp0

:: Check if program argument is provided
if "%~1"=="" (
  echo Usage: %0 [vscode^|cursor]
  exit /b 1
)

set PROGRAM=%~1
set OUTPUT_FILE=extensions.%PROGRAM%.txt

if "%PROGRAM%"=="vscode" (
  code --list-extensions > "%OUTPUT_FILE%"
) else if "%PROGRAM%"=="cursor" (
  cursor --list-extensions > "%OUTPUT_FILE%"
) else (
  echo Invalid program. Use 'vscode' or 'cursor'
  exit /b 1
)
