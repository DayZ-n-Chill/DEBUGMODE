SETLOCAL ENABLEDELAYEDEXPANSION

SET "MODS="
SET "MODDIR=P:\Mods\"
FOR %%m IN (
    @CF
    @Dabs-Framework
    @Community-Online-Tools
) DO SET "MODS=!MODS!!MODDIR!%%m;"
echo SET "MODS=%MODS%"

SET "SEVERSIDEMODS="
SET "PROFILES=%~dp0profiles"
SET "CLIENTLOGS=%~dp0clientLogs"
SET "SERVERCFG=%~dp0serverDZ.cfg"
SET "MISSION=%~d0\DebugMode\Missions\dayzOffline.chernarusplus"
SET "GAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ\"
SET "LOCALHOST=127.0.0.1:2302"

start "" "%GAMEDIR%\DayZDiag_x64.exe" -mod=%MODS% -profiles=%CLIENTLOGS% -connect=%LOCALHOST% -battleye=0 -filepatching=1
start "" "%GAMEDIR%\DayZDiag_x64.exe" -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1
