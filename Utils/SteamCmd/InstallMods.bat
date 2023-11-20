@echo off
title DayZ n' Chill Server Mod Installation

echo Checking if Chocolatey is installed...
:: Check if Chocolatey is installed, if not, install it
if not exist "%ProgramData%\chocolatey\choco.exe" (
    @powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ProgramData%\chocolatey\bin"
    echo Chocolatey installed successfully!
) else (
    echo Chocolatey is already installed!
)
pause

echo Installing curl and 7-Zip using Chocolatey...
choco install curl -y
choco install 7zip -y
echo curl and 7-Zip installed successfully!
pause

echo Creating directory for steamcmd...
if not exist "%~dp0..\steamcmd" mkdir "%~dp0..\steamcmd"
echo Directory created or already exists!
pause

echo Downloading steamcmd using curl...
cd "%~dp0..\"
curl -k -O https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip
echo steamcmd downloaded successfully!
pause

echo Extracting steamcmd...
"C:\Program Files\7-Zip\7z.exe" e steamcmd.zip
echo Extraction complete!
pause

echo Installing steamcmd...
cd steamcmd
.\steamcmd.exe
echo steamcmd installed!
pause

echo Deleting the downloaded zip file...
del steamcmd.zip
echo Zip file deleted!
pause

echo Downloading workshop item using steamcmd...
set steam_username=digitalreligion
set steam_password=xFKcfF255RiGYzHU
set workshop_id=1559212036
.\steamcmd.exe +login %steam_username% %steam_password% +workshop_download_item 221100 %workshop_id% +quit
echo Workshop item downloaded!
pause
