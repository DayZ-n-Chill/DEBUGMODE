@echo off

:: Uninstall packages installed by Chocolatey
choco uninstall -y curl 7zip

:: Remove the steamcmd directory (assuming it's empty)
rd /s /q "C:\steamcmd"

:: Uninstall Chocolatey (optional)
:: choco uninstall -y chocolatey

:: Display a message
echo Uninstallation completed.

:: Pause to let the user read the message
pause
