@echo off
title YourBatchWindowTitle
:: Check if Chocolatey is installed, if not, install it
if not exist "%ProgramData%\chocolatey\choco.exe" (
    @powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ProgramData%\chocolatey\bin"
)

:: Use Chocolatey to install curl and 7-Zip
choco install curl -y
choco install 7zip -y

:: Create a directory for steamcmd if it doesn't exist
if not exist C:\steamcmd mkdir C:\steamcmd

:: Navigate to the directory
cd C:\steamcmd

:: Download steamcmd using curl
curl -k -O https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip


:: Extract the downloaded file using 7-Zip
"C:\Program Files\7-Zip\7z.exe" e steamcmd.zip

:: Delete the downloaded zip file after extraction
del steamcmd.zip

:: Download workshop item using steamcmd
:: NOTE - This account has nothing but DayZ in it.
:: So stealing this or doing whatever will not only result in your permanant ban
:: But could result in legal actions as well.  Dont fuck with my shit!
set steam_username=digitalreligion
set steam_password=Zxcasdqwe123!23
set workshop_id=1559212036

C:\steamcmd\steamcmd.exe +login %steam_username% %steam_password% +workshop_download_item 221100 %workshop_id% +quit

echo Workshop item downloaded!
pause
