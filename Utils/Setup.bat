@echo off
SETLOCAL
type .\Batch\Logo\devlogo.txt
call .\Batch\Setup\WorkshopSync.bat
echo.
IF EXIST "C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop" (
    powershell -Command "Write-Host 'C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop exists.' -ForegroundColor Yellow"
    powershell -Command "Write-Host 'Setup will now Sync setup with your DayZ install on the C Drive.' -ForegroundColor DarkCyan"
    call .\Batch\Setup\DriveSyncC.bat
) ELSE (
    IF EXIST "D:\SteamLibrary\steamapps\common\DayZ\!Workshop" (
        powershell -Command "Write-Host 'D:\SteamLibrary\steamapps\common\DayZ\!Workshop exists.' -ForegroundColor Yellow"
        powershell -Command "Write-Host 'Setup will now Sync setup with your DayZ install on the D Drive.' -ForegroundColor DarkCyan"
    ) ELSE (
        powershell -Command "Write-Host 'D:\SteamLibrary\steamapps\common\DayZ\!Workshop does not exists.' -ForegroundColor Red"
        pause
        call .\Batch\Setup\DriveSyncD.bat
        pause
        exit
    )
)
ENDLOCAL
pause
