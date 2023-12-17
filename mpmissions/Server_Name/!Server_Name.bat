@echo off
SET "MODS="
SET "SEVERSIDEMODS="
SET "DIAGNOSTICMODE=false"  
SET "DAYZGAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"
SET "DAYZSERVERDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
SET "WORKSHOPDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
SET "SERVERCFG=DEBUGMODE\mpmissions\Server_Name\serverDZ.cfg"
SET "MISSION=DEBUGMODE\mpmissions\Server_Name\dayzOffline.chernarusplus"
SET "PROFILES=DEBUGMODE\mpmissions\Server_Name\profiles"
SET "LOCALHOST=127.0.0.1:2302"
SET "PDRIVE=P:\"
SET "MODDIR=P:\Mods"
powershell -Command "Write-Host 'Initializing Mods and Starting Chernarus Server' -ForegroundColor DarkCyan"
if "%DIAGNOSTICMODE%"=="true" (
    start "" "%DAYZGAMEDIR%\DayZDiag_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battylee=0 -filepatching=1
    start "" "%DAYZGAMEDIR%\DayZDiag_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
) else (
    start "" "%DAYZGAMEDIR%\DayZ_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battylee=0 -filepatching=1
    start "" "%DAYZSERVERDIR%\DayZServer_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
)
