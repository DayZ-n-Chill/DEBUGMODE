@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

type ..\..\Utils\Batch\Logo\devlogo.txt
SET "WorkshopLink=P:\Mods"
SET "WorkshopDir=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"

echo.
powershell -Command "Write-Host 'Checking for the existence of %WorkshopLink%...' -ForegroundColor Cyan"
echo.
IF NOT EXIST "%WorkshopLink%" (
    powershell -Command "Write-Host '%WorkshopLink% does not exist. Checking for %WorkshopDir%...' -ForegroundColor Yellow"
    echo.
    IF EXIST "%WorkshopDir%" (
        powershell -Command "Write-Host '%WorkshopDir% found. Creating a junction point...' -ForegroundColor Green"
        echo.
        mklink /J "%WorkshopLink%" "%WorkshopDir%"
        IF ERRORLEVEL 1 (
            powershell -Command "Write-Host 'Failed to create junction point. Make sure you have the required permissions.' -ForegroundColor Red"
        ) ELSE (
            powershell -Command "Write-Host 'Junction point created successfully.' -ForegroundColor DarkGreen"
        )
        echo.
    ) ELSE (
        powershell -Command "Write-Host '%WorkshopDir% does not exist. Please check the path.' -ForegroundColor Red"
        echo.
    )
) ELSE (
    powershell -Command "Write-Host '%WorkshopLink% already exists.' -ForegroundColor DarkCyan"
    echo.
)

SET "MODS="
SET "MODDIR=P:\Mods"
SET "MODLIST=@CF;@Dabs Framework;@Community-Online-Tools;@Mod With Spaces;@Another mod on the list"

REM Process each mod in the MODLIST
:nextmod
    FOR /F "tokens=1* delims=;" %%a IN ("%MODLIST%") DO (
        SET "MOD=%%a"
        SET "MODLIST=%%b"
        SET "MOD_FOLDER=!WorkshopLink!\!MOD!"
        IF EXIST "!MOD_FOLDER!" (
            powershell -Command "Write-Host '!MOD!' found in !WorkshopLink! -ForegroundColor Green"
            SET "MODS=!MODS!!MODDIR!\!MOD!;"
        ) ELSE (
            powershell -Command "Write-Host '!MOD!' not found in !WorkshopLink! -ForegroundColor Red"
        )
    )
    IF NOT "!MODLIST!"=="" GOTO nextmod

pause
powershell -Command "Write-Host 'MODS=!MODS!' -ForegroundColor DarkCyan"
pause

SET "SEVERSIDEMODS="
SET "PROFILES=%~dp0profiles"
SET "CLIENTLOGS=%~dp0clientLogs"
SET "SERVERCFG=%~dp0serverDZ.cfg"
SET "MISSION=%~d0\DebugMode\Missions\dayzOffline.chernarusplus"
SET "GAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"
SET "LOCALHOST=127.0.0.1:2302"

start "" "%GAMEDIR%\DayZDiag_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battleye=0 -filepatching=1
start "" "%GAMEDIR%\DayZDiag_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1