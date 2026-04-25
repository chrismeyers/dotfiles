@echo off

:: Change directory to this script.
cd %~dp0

:: Only trigger an install if there are missing extensions.
setlocal EnableDelayedExpansion

set /a installedCount=0
for /f "delims=" %%e in ('cursor --list-extensions') do (
  set "installed[!installedCount!]=%%e"
  set /a installedCount+=1
)

set /a backedupCount=0
for /f "usebackq tokens=* delims=" %%a in ("extensions.txt") do (
  if not "%%a"=="" (
    set "backedup[!backedupCount!]=%%a"
    set /a backedupCount+=1
  )
)

set "missing=false"
for /L %%i in (0,1,!backedupCount!-1) do (
  set "item=!backedup[%%i]!"
  set "found=false"

  for /L %%j in (0,1,!installedCount!-1) do (
    if /I "!installed[%%j]!"=="!item!" set "found=true"
  )

  if "!found!"=="false" (
    set "missing=true"
    goto :check_done
  )
)

:check_done

if "!missing!"=="false" exit /b 0

:: Install each extension.
for /f "tokens=*" %%a in (extensions.txt) do (
  cursor --install-extension %%a
)
