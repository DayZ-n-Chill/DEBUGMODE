@echo off
SET "MODS="
SET "SEVERSIDEMODS="
SET "DEBUGFOLDER=DEBUGMODE" 
SET "SERVERCFG=%DEBUGFOLDER%\mpmissions\Server_Name\serverDZ.cfg"
SET "MISSION=%DEBUGFOLDER%\mpmissions\Server_Name\dayzOffline.chernarusplus"
SET "PROFILES=%DEBUGFOLDER%\mpmissions\Server_Name\profiles"
SET "CLIENTDIAGLOGS=%DEBUGFOLDER%\!ClientDiagLogs"
SET "LOCALHOST=127.0.0.1:2302"
SET "GAMEDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ"
SET "WORKSHOPDIR=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"
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
