@echo off
SETLOCAL
REM This script will create a junction to the Workshop directory on the P drive
REM You just need to  to provide the path to the Workshop directory.
SET "WorkshopDir=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
REM The secondayt workshop directory for those people on your dev team who just refuse to conform 
REM and is installing their steam on a seperate drive than where the rest of the team is installing it 😉
SET "SecondaryWorkshopDir=D:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"

REM Symlink your !Workshop directory to your P drive
REM This give the .BAT file access to the hidden !workshop folder. 
REM (Dont modify this folder.)
SET "MODDIR=P:\Mods"

REM Check if the P drive is mounted
IF NOT EXIST "P:\" (
    powershell -Command "Write-Host 'WARNING: The P drive is not mounted. Please ensure it is mounted before continuing.' -ForegroundColor Red"
    pause
    exit /b
)

REM Check if the Workshop directory exists
IF NOT EXIST "%WorkshopDir%" (
    powershell -Command "Write-Host 'WARNING: The Workshop directory provided does not exist ' -ForegroundColor Red"
    echo Provided Folder: "%WorkshopDir%".
    echo Please make sure the Workshop folder is located there.
    pause
    exit /b
)

REM Create a junction from the Workshop directory to the target directory on the P drive
mklink /J "%MODDIR%" "%WorkshopDir%"

REM Check if the junction was created successfully
IF ERRORLEVEL 1 (
    powershell -Command "Write-Host 'WARNING: P:\Mods\ already exists, Carry On!' -ForegroundColor Magenta"
) ELSE (
    powershell -Command "Write-Host 'Junction created successfully.' -ForegroundColor Green"
    echo Workshop mods are linked to "%MODDIR%" on the P drive.
)

ENDLOCAL
pause
