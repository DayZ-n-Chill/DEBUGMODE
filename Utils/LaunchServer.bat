@echo off
SETLOCAL
type .\Batch\Logo\devlogo.txt
echo.
echo Cleaning Logs and Starting Launch Process...
call .\Servers\dznc.us1\CleanLogs
IF EXIST "C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop" (
    powershell -Command "Write-Host 'C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop exists.' -ForegroundColor Yellow"
    powershell -Command "Write-Host 'Launching Server from C Drive.' -ForegroundColor DarkCyan"
    pause
    call ..\Servers\dznc.us1\CleanLogs
    call ..\Servers\dznc.us1\!StartServer_C.bat
) ELSE (
    IF EXIST "D:\SteamLibrary\steamapps\common\DayZ\!Workshop" (
        powershell -Command "Write-Host 'D:\SteamLibrary\steamapps\common\DayZ\!Workshop exists.' -ForegroundColor Yellow"
        powershell -Command "Write-Host 'Launching Server from D Drive.' -ForegroundColor DarkCyan"
    ) ELSE (
        powershell -Command "Write-Host 'D:\SteamLibrary\steamapps\common\DayZ\!Workshop does not exists.' -ForegroundColor Red"
        pause
    call ..\Servers\dznc.us1\CleanLogs
    call ..\Servers\dznc.us1\!StartServer_D.bat
        pause
        exit
    )
)
ENDLOCAL
