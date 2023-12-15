@echo off
SETLOCAL
type .\Batch\Logo\devlogo.txt
echo.
echo Starting Build and Launch Process...
IF EXIST "C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop" (
    powershell -Command "Write-Host 'C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop exists.' -ForegroundColor Yellow"
    powershell -Command "Write-Host 'Building Mods to workshop folder on C Drive' -ForegroundColor DarkCyan"
    pause
    call .\Batch\Build\BuildMods_C.bat
)
ENDLOCAL
