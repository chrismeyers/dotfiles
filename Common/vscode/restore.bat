@echo off

:: Change directory to this script.
cd %~dp0

:: Check if program argument is provided
if "%~1"=="" (
  echo Usage: %0 [vscode^|cursor]
  exit /b 1
)

set PROGRAM=%~1
set INPUT_FILE=extensions.%PROGRAM%.txt

if not exist "%INPUT_FILE%" (
  echo Error: %INPUT_FILE% not found
  exit /b 1
)

:: Install each extension
if "%PROGRAM%"=="vscode" (
  for /f "tokens=*" %%a in (%INPUT_FILE%) do (
    code --install-extension %%a
  )
) else if "%PROGRAM%"=="cursor" (
  for /f "tokens=*" %%a in (%INPUT_FILE%) do (
    cursor --install-extension %%a
  )
) else (
  echo Invalid program. Use 'vscode' or 'cursor'
  exit /b 1
)
