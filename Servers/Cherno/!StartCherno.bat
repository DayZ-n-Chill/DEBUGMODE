@echo off
REM ====================================================================================================================
REM  DayZ Mod Manager & Server Launcher by: DayZ n' Chill
REM ====================================================================================================================
REM  This script efficiently manages DayZ mods and facilitates launching a DayZ Diagnostic Server.
REM  It achieves this by creating necessary junction points for mods, establishing links, and then initiating the server.
REM  The primary aim of this script is to simplify mod and server management, especially for users who may not be
REM  experienced modders or developers.
REM
REM  Special Features:
REM  ----------------
REM  - Tailored to work seamlessly with the !Workshop folder.
REM  - Handles mod names with spaces or other delimiters without duplicating files, or compromising code integrity.
REM
REM  IMPORTANT NOTES:
REM  ----------------
REM  - Ensure your P drive is set up before running this script.
REM  
REM  SETUP YOUR DEBUG & YOUR MODS:
REM  ----------------------------
REM  - Set DayZ Game Installation & Workshop Directory
REM  - List your mods as named in your !Workshop folder. IE: @CF;@Dabs Framework;@Community-Online-Tools;Colorful-UI
REM  - Add your server-side mods if any.

REM ====================================================================================================================
REM  User Configuration
REM ====================================================================================================================
REM  Only change this DEBUGFOLDER Variable if you change the root of your folder. 
SET "GAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"
SET "WORKSHOPDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
SET "MODLIST=@CF;@Dabs Framework;@Community-Online-Tools;"
SET "SEVERSIDEMODS="
SET "DEBUGFOLDER=DEBUGMODE" 

REM ====================================================================================================================
REM  Script Initialization - DO NOT MODIFY BELOW THIS LINE
REM ====================================================================================================================
SET "LOCALHOST=127.0.0.1:2302"
SET "MISSION=%DEBUGFOLDER%\Missions\dayzOffline.chernarusplus"
SET "SERVERCFG=%DEBUGFOLDER%\Servers\Cherno\serverDZ.cfg"
SET "PROFILES=%DEBUGFOLDER%\Servers\Cherno\profiles"
SET "CLIENTDIAGLOGS=%DEBUGFOLDER%\!ClientDiagLogs"
SET "PDRIVE=P:\"
SET "MODDIR=P:\Mods"

REM Checking Directories
type "..\..\Utils\Batch\Logo\happyHacking.txt"
FOR %%D IN ("%GAMEDIR%|DayZ installation directory" "%WORKSHOPDIR%|Steam !Workshop directory" "%PDRIVE%|P:\ Drive directory") DO (
    FOR /F "tokens=1,* delims=|" %%A IN ("%%D") DO (
        SET "CURRENT_DIR=%%~A"
        SET "DESCRIPTION=%%~B"
    )
    SETLOCAL ENABLEDELAYEDEXPANSION
    IF NOT EXIST "!CURRENT_DIR!" (
        powershell -Command "Write-Host 'Error: !DESCRIPTION! not found at !CURRENT_DIR!' -ForegroundColor Red"
    ) ELSE (
        powershell -Command "Write-Host 'Success: !DESCRIPTION! found.' -ForegroundColor Green"
    )
    ENDLOCAL
)
echo.
pause
REM Junction Point Creation
powershell -Command "Write-Host 'Checking for the existence of %MODDIR%...' -ForegroundColor Cyan"
IF NOT EXIST "%MODDIR%" (
    powershell -Command "Write-Host '%MODDIR% does not exist. Checking for %WorkshopDir%...' -ForegroundColor Yellow"
    echo.

    IF EXIST "%WorkshopDir%" (
        powershell -Command "Write-Host '%WorkshopDir% found. Creating a junction point...' -ForegroundColor Green"
        echo.

        mklink /J "%MODDIR%" "%WorkshopDir%"

        IF ERRORLEVEL 1 (
            powershell -Command "Write-Host 'Failed to create junction point. Make sure you have the required permissions.' -ForegroundColor Red"
        ) ELSE (
            powershell -Command "Write-Host 'Junction point created successfully.' -ForegroundColor DarkGreen"
        )
        echo.

    ) ELSE (
        powershell -Command "Write-Host '%WorkshopDir% does not exist. Please check the path.' -ForegroundColor Red"
    )
) ELSE (
    powershell -Command "Write-Host '%MODDIR% already exists.' -ForegroundColor DarkCyan"
    echo.
)
SETLOCAL ENABLEDELAYEDEXPANSION
:nextmod
FOR /F "tokens=1* delims=;" %%a IN ("%MODLIST%") DO (
    SET "MOD=%%a"
    SET "MODLIST=%%b"
    SET "MOD_FOLDER=!MODDIR!\!MOD!"
    SET "MOD_DIR_FOLDER=!MODDIR!\!MOD!"
    IF EXIST "!MOD_DIR_FOLDER!" (
        echo "!MOD!" | findstr /C:" " > nul
        IF NOT ERRORLEVEL 1 (
            SET "NEW_MOD=!MOD: =-!"
            SET "NEW_MOD_FOLDER=!MODDIR!\!NEW_MOD!"
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
            echo "!MOD_NO_SPACE!" found in !MODDIR!
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
REM Starting the Server
powershell -Command "Write-Host 'Initializing Mods and Starting Chernarus Server' -ForegroundColor DarkCyan"
start "" "%GAMEDIR%\DayZDiag_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battylee=0 -filepatching=1
start "" "%GAMEDIR%\DayZDiag_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
pause