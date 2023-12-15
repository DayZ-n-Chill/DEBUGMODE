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
REM !!!! IMPORTANT NOTE:  YOU MUST HAVE YOUR P DRIVE SETUP PRIOR TO RUNNING THIS APP  !!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM !!!! SETUP YOUR DEBUG & YOUR MODS HERE !!!!
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM List your mods exactly as they are named in your !Workshop folder.
REM Example: SET "MODLIST=@CF;@Dabs Framework;@Community-Online-Tools;@BoomLay's Things"
SET "MODLIST=@CF;@Dabs Framework;@Community-Online-Tools;"
REM Add your serverside mods here. 
SET "SEVERSIDEMODS="
REM Set and Verify the DayZ Game Installation & Workshop Directory
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
SET "LOCALHOST=127.0.0.1:2302"
SET "SERVERCFG=%DEBUGFOLDER%\mpmissions\Cherno\serverDZ.cfg"
SET "MISSION=%DEBUGFOLDER%\mpmissions\Cherno\dayzOffline.chernarusplus"
SET "PROFILES=%DEBUGFOLDER%\mpmissions\Cherno\profiles"
SET "CLIENTDIAGLOGS=%DEBUGFOLDER%\!ClientDiagLogs"
SET "PDRIVE=P:\"
SET "MODDIR=P:\Mods"
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
powershell -Command "Write-Host 'Initializing Mods and Starting Chernarus Server' -ForegroundColor DarkCyan"
start "" "%GAMEDIR%\DayZDiag_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battylee=0 -filepatching=1
start "" "%GAMEDIR%\DayZDiag_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
