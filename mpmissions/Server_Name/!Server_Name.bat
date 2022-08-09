@echo off
@REM List of client mods used on this server. / NOTE: must be outside the "!workshop" directory - I recommend the DayZ root folder
SET "MODS="

@REM List of mods used that run only on the server. 
SET "SEVERSIDEMODS="

@REM Directory to your Servers Config Files
SET "SERVERCFG=DEBUGMODE\mpmissions\Server_Name\serverDZ.cfg"

@REM Directory to your Servers Mission Files 
SET "MISSION=DEBUGMODE\mpmissions\Server_Name\dayzOffline.chernarusplus"

@REM Directory to your Servers Profiles Folder
SET "PROFILES=DEBUGMODE\mpmissions\Server_Name\profiles"

@REM !!! Dont Edit this stuff below this line unless you know what you are doing.!!!

@REM Local IP Address for server to run on.
SET "LOCALHOST=127.0.0.1:2302"

@REM Path to the DayZDiag_x64.exe from this file 
cd ../../../

@REM Start Game
start DayZDiag_x64.exe -mod=%MODS% -profiles=!ClientDiagLogs -connect=%LOCALHOST% -battleye=0 -filepatching=1

@REM Start The Server 
start DayZDiag_x64.exe -server -noPause -doLogs -mission=%MISSION% -config=%SERVERCFG% -profiles=%PROFILES% -mod=%MODS% -serverMod=%SEVERSIDEMODS% -filepatching=1