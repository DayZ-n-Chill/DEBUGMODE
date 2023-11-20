@echo off
SETLOCAL
echo.
echo Checking and creating symbolic links for Server mod development...
FOR %%D IN (ModsClient ModsServer) DO (
    IF NOT EXIST "P:\%%D" (
        powershell -Command "Write-Host 'Attempting to create symbolic link for %%D...' -ForegroundColor DarkCyan"
        mklink /J "P:\%%D" "..\%%D"
        IF ERRORLEVEL 1 (
            powershell -Command "Write-Host 'Failed to create symbolic link for %%D.' -ForegroundColor Red"
        ) ELSE (
            powershell -Command "Write-Host 'Symbolic link for %%D created successfully!' -ForegroundColor DarkGreen"
        )
    ) ELSE (
        powershell -Command "Write-Host 'Symbolic link for %%D already exists.' -ForegroundColor DarkCyan"
    )
)
ENDLOCAL
echo.
powershell -Command "Write-Host 'Done syncing ModsClient and ModsServer folders.' -ForegroundColor DarkGreen"
echo.
pause
