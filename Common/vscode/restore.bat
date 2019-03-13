@echo off

:: Change directory to this script.
cd %~dp0

:: Install each extension
for /f "tokens=*" %%a in (extensions.txt) do (
  code --install-extension %%a
)
