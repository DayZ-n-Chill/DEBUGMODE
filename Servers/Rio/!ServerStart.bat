@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM DayZ Mod Manager and Server Launcher
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM This batch script serves the dual purpose of efficiently managing DayZ mods and facilitating the launch of a DayZ server with these mods.
REM It achieves this by creating necessary junction points for mods, establishing links, and then initiating the server.
REM The primary aim of this script is to simplify mod and server management, especially for users who may not be experienced modders or developers.
REM Furthermore, it is tailored to seamlessly work with the !Workshop folder, a feature that sets it apart from many other BAT files available.
REM In cases where mod names include spaces or other delimiters, this script seamlessly handles these issues without compromising the integrity
REM of the original code or duplicating files.
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM !!!! IMPORTANT NOTE:   YOU MUST HAVE YOUR P DRIVE SETUP PRIOR TO RUNNING THIS APP    !!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM !!!! SET UP YOUR MODS HERE !!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

REM Set the location of your DayZ Installation
SET "GAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"

REM Set the location of your Steam !Workshop folder. It is currently set to default
SET "WorkshopDir=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"

REM Set the location of your world
SET "MISSION=%~d0\DebugMode\Missions\dayzOffline.Rio_Map"

REM List your mods exactly as they are named in your !Workshop folder.
REM Example: SET "MODLIST=@CF;@Dabs Framework;@Community-Online-Tools;@BoomLay's Things"
SET "MODLIST=@Rio Map - Experimental"

REM Add your serverside mods here. 
SET "SEVERSIDEMODS="

REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM WARNING!!! DO NOT MODIFY BELOW THIS LINE!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET "PROFILES=%~dp0profiles"
SET "CLIENTLOGS=%~dp0clientLogs"
SET "SERVERCFG=%~dp0serverDZ.cfg"
SET "LOCALHOST=127.0.0.1:2302"

type ..\..\Utils\Batch\Utils\devlogo.txt

SET "MODS="
SET "MODDIR=P:\Mods"
SET "WorkshopLink=P:\Mods"

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

:nextmod
FOR /F "tokens=1* delims=;" %%a IN ("%MODLIST%") DO (
    SET "MOD=%%a"
    SET "MODLIST=%%b"
    SET "MOD_FOLDER=!WorkshopLink!\!MOD!"
    SET "MOD_DIR_FOLDER=!MODDIR!\!MOD!"
    IF EXIST "!MOD_DIR_FOLDER!" (
        echo "!MOD!" | findstr /C:" " > nul
        IF NOT ERRORLEVEL 1 (
            SET "NEW_MOD=!MOD: =-!"
            SET "NEW_MOD_FOLDER=!WorkshopLink!\!NEW_MOD!"
            IF NOT EXIST "!NEW_MOD_FOLDER!" (
                mklink /J "!NEW_MOD_FOLDER!" "!MOD_FOLDER!" > nul
                IF ERRORLEVEL 1 (
                    SET "MOD_ERROR=!MOD!"
                    echo Failed to create junction for "!MOD_ERROR!". Make sure you have the required permissions. >&2
                ) ELSE (
                    SET "MOD_SUCCESS=!MOD!"
                    powershell -Command "Write-Host 'Junction created successfully.' -ForegroundColor Magenta"
                    echo "!MOD_SUCCESS!" Successfully linked.
                    SET "MODS=!MODS!!MODDIR!\!NEW_MOD!;"
                )
            ) ELSE (
                SET "MOD_EXISTS=!MOD!"
                powershell -Command "Write-Host 'Successfully Loaded.' -ForegroundColor Green"
                echo "!MOD_EXISTS!" already exists.
                SET "MODS=!MODS!!MODDIR!\!NEW_MOD!;"
            )
        ) ELSE (
            SET "MOD_NO_SPACE=!MOD!"
            echo "!MOD_NO_SPACE!" found in !WorkshopLink!
            SET "MODS=!MODS!!MODDIR!\!MOD!;"
        )
    ) ELSE (
        SET "MOD_NOT_FOUND=!MOD!"
        powershell -Command "Write-Host 'Mod not found in "!MODDIR!" - skipping.' -ForegroundColor Red"
        powershell -Command "Write-Host 'You probably need to download the mod.' -ForegroundColor Blue"
        echo "!MOD_NOT_FOUND!"
    )
)
IF NOT "!MODLIST!"=="" GOTO nextmod
pause

powershell -Command "Write-Host 'Initializing Mods and Starting Livonia Server' -ForegroundColor DarkCyan"
@REM Uncomment below to debug the mods being loaded. This shows the mods actually being loaded in the MODS Variable
@REM echo "MODS=!MODS!"
@REM pause

start "" "%GAMEDIR%\DayZDiag_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battleye=0 -filepatching=1
start "" "%GAMEDIR%\DayZDiag_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1

powershell -Command "Write-Host 'ENJOY YOUR SERVER, AND HAPPY MODDING!' -ForegroundColor Magenta"
@REM Remove the pause at the end if you dont want to see the mods being loaded

Pause
