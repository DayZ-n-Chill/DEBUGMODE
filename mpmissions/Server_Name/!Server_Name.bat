
@echo off
SET MODS=P:\Mods\@CF;P:\Mods\@VPPAdminTools;
SET SEVERSIDEMODS=""
SET DIAGNOSTICMODE="false"  
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

@REM Path to the DayZDiag_x64.exe from this file 
cd ../../../

@REM Start Game
@REM start DayZ_x64.exe "-mod=%MODS%" -profiles=!ClientDiagLogs -connect=%LOCALHOST% -battleye=0 -filepatching=1

@REM Start The Server 
cd C:\Program Files (x86)\Steam\steamapps\common\DayZServer
start DayZDiag_x64.exe -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% "-mod=%MODS%" -serverMod=%SEVERSIDEMODS% -filepatching=1