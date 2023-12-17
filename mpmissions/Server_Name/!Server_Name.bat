@echo off
SET MODS=""
SET SEVERSIDEMODS=""
SET DIAGNOSTICMODE="true"  
SET "DAYZGAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"
SET "DAYZSERVERDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
SET "WORKSHOPDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
SET "SERVERCFG=DEBUGMODE\mpmissions\Server_Name\serverDZ.cfg"
SET "MISSION=DEBUGMODE\mpmissions\Server_Name\dayzOffline.chernarusplus"
SET "PROFILES=DEBUGMODE\mpmissions\Server_Name\profiles"
SET "LOCALHOST=127.0.0.1:2302"
SET "MODLIST="
SET "PDRIVE=P:\"
SET "MODDIR=P:\Mods"

REM Create a Junction of !Workshop folder to P:\Drive. This will be used for filepatching.
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
REM Start the selected server type
powershell -Command "Write-Host 'Initializing Mods and Starting Chernarus Server' -ForegroundColor DarkCyan"
if "%DIAGNOSTICMODE%"=="true" (
    start "" "%DAYZGAMEDIR%\DayZDiag_x64.exe" "-mod=%MODS%" -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battylee=0 -filepatching=1
    start "" "%DAYZGAMEDIR%\DayZDiag_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
) else (
    start "" "%DAYZGAMEDIR%\DayZ_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battylee=0 -filepatching=1
    start "" "%DAYZSERVERDIR%\DayZServer_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
)
REM Shutdown terminal
powershell -Command "Write-Host 'This Terminal will self destruct in 5 seconds...' -ForegroundColor Yellow"
timeout /t 5 /nobreak >nul
exit