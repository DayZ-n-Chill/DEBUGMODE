@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

type ..\..\Utils\Batch\Utils\devlogo.txt
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
SET "MODLIST=@CF;@Dabs Framework;@Community-Online-Tools;@Mod With Spaces;@BoomLay's Things"

REM Process each mod in the MODLIST
:nextmod
    FOR /F "tokens=1* delims=;" %%a IN ("%MODLIST%") DO (
        SET "MOD=%%a"
        SET "MODLIST=%%b"
        SET "MOD_FOLDER=!WorkshopLink!\!MOD!"
        SET "MOD_DIR_FOLDER=!MODDIR!\!MOD!"

        REM Check if the mod is in the MODDIR and if the mod name contains a space
        IF EXIST "!MOD_DIR_FOLDER!" (
            echo "!MOD!" | findstr /C:" " > nul
            IF NOT ERRORLEVEL 1 (
                REM Mod name contains a space, prepare to create a junction with hyphens
                SET "NEW_MOD=!MOD: =-!"
                SET "NEW_MOD_FOLDER=!WorkshopLink!\!NEW_MOD!"

                IF NOT EXIST "!NEW_MOD_FOLDER!" (
                    REM Create a junction only if it does not already exist
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
                REM Mod name does not contain a space, add it to MODS as is
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
powershell -Command "Write-Host 'Loading Mods and Starting Server' -ForegroundColor DarkCyan"
echo "MODS=!MODS!"
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

powershell -Command "Write-Host 'ENJOY YOUR SERVER, AND HAPPY MODDING!' -ForegroundColor Green"
Pause
