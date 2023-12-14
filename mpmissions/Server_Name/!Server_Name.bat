@echo off
SET "MODS="
SET "SEVERSIDEMODS="
SET "SERVERCFG=DEBUGMODE\mpmissions\Server_Name\serverDZ.cfg"
SET "MISSION=DEBUGMODE\mpmissions\Server_Name\dayzOffline.chernarusplus"
SET "PROFILES=DEBUGMODE\mpmissions\Server_Name\profiles"
SET "CLIENTDIAGLOGS=DEBUGMODE\!ClientDiagLogs"
SET "LOCALHOST=127.0.0.1:2302"

SET "GAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"
IF NOT EXIST "%GAMEDIR%" (
    powershell -Command "Write-Host 'Error: DayZ Installation directory not found at %GAMEDIR%' -ForegroundColor Red"
) ELSE (
    powershell -Command "Write-Host 'Success: DayZ Installation directory found.' -ForegroundColor Green"
)

cd %GAMEDIR%

start DayZDiag_x64.exe -mod=%MODS% -profiles=%CLIENTDIAGLOGS% -connect=%LOCALHOST% -battleye=0 -filepatching=1
start DayZDiag_x64.exe -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
