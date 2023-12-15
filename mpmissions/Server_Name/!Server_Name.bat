@echo off
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
REM !!!! IMPORTANT NOTE:   YOU MUST HAVE YOUR P DRIVE SETUP PRIOR TO RUNNING THIS APP    !!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM !!!! SETUP YOUR DEBUG & YOUR MODS HERE !!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET "MODS="
SET "SEVERSIDEMODS="
SET "GAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"
SET "WORKSHOPDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM If you need to change the folder name of the root folder.
REM Change the name of the DEBUGFOLDER Variable above as well.
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET "DEBUGFOLDER=DEBUGMODE" 
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM NOTE: Dynamic folder syncing is an issue at the moment and for some rando reason stopped working as of DayZ 1.25
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM WARNING!!! DO NOT MODIFY BELOW THIS LINE!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET "SERVERCFG=%DEBUGFOLDER%\mpmissions\Server_Name\serverDZ.cfg"
SET "MISSION=%DEBUGFOLDER%\mpmissions\Server_Name\dayzOffline.chernarusplus"
SET "PROFILES=%DEBUGFOLDER%\mpmissions\Server_Name\profiles"
SET "CLIENTDIAGLOGS=%DEBUGFOLDER%\!ClientDiagLogs"
SET "LOCALHOST=127.0.0.1:2302"
SET "PDRIVE=p:\"
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
pause
cd %GAMEDIR%
start DayZDiag_x64.exe -mod=%MODS% -profiles=%CLIENTDIAGLOGS% -connect=%LOCALHOST% -battleye=0 -filepatching=1
start DayZDiag_x64.exe -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
