@echo off
SETLOCAL
SET WorkshopLink=P:\Mods
SET WorkshopDir=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop
echo.
echo Checking and creating symbolic links for loading installed mod dependencies...
IF NOT EXIST "%WorkshopLink%" (
    echo Attempting to create symbolic link for mods...
    mklink /J "%WorkshopLink%" "%WorkshopDir%"
    IF ERRORLEVEL 1 (
        powershell -Command "Write-Host 'Failed to create symbolic link for mods.!' -ForegroundColor Red"
    ) ELSE (
        powershell -Command "Write-Host 'Symbolic link for mods created successfully!' -ForegroundColor DarkGreen"
    )
) ELSE (
    powershell -Command "Write-Host 'Symbolic link for mods already exists.' -ForegroundColor DarkCyan"
)
echo.
powershell -Command "Write-Host 'Done loading installed mod dependencies.' -ForegroundColor DarkGreen"
echo.

:: Check if the directory "@Dabs Framework" exists
IF EXIST "%WorkshopDir%\@Dabs Framework" (
    powershell -Command "Write-Host 'Found @Dabs Framework' -ForegroundColor Yellow"
    
    :: Create a symbolic link called "@Dabs-Framework" pointing to "@Dabs Framework" if it doesn't already exist
    IF NOT EXIST "%WorkshopDir%\@Dabs-Framework" (
        mklink /J "%WorkshopDir%\@Dabs-Framework" "%WorkshopDir%\@Dabs Framework"
        IF ERRORLEVEL 1 (
            powershell -Command "Write-Host 'Failed to create symbolic link for @Dabs-Framework' -ForegroundColor Red"
            echo.
        ) ELSE (
            powershell -Command "Write-Host 'Symbolic link for @Dabs-Framework already created successfully!' -ForegroundColor DarkGreen"
            echo.
        )
    ) ELSE (
        powershell -Command "Write-Host 'Symbolic link for @Dabs-Framework already exists' -ForegroundColor DarkCyan"
        echo.
    )
) ELSE (
    powershell -Command "Write-Host '@Dabs-Framework not found in !Workshop folder' -ForegroundColor Red"
    echo.
)

:: Check if the directory "@LoftDModGR Clothes Pack" exists
IF EXIST "%WorkshopDir%\@LoftDModGR Clothes Pack" (
    powershell -Command "Write-Host 'Found @LoftDModGR Clothes Pack' -ForegroundColor Yellow"
    
    :: Create a symbolic link called "@LoftDModGR-Clothes-Pack" pointing to "@LoftDModGR Clothes Pack" if it doesn't already exist
    IF NOT EXIST "%WorkshopDir%\@LoftDModGR-Clothes-Pack" (
        mklink /J "%WorkshopDir%\@LoftDModGR-Clothes-Pack" "%WorkshopDir%\@LoftDModGR Clothes Pack"
        IF ERRORLEVEL 1 (
            powershell -Command "Write-Host 'Failed to create symbolic link for @LoftDModGR-Clothes-Pack' -ForegroundColor Red"
            echo.
        ) ELSE (
            powershell -Command "Write-Host 'Symbolic link for @LoftDModGR-Clothes-Pack created successfully!' -ForegroundColor DarkGreen"
            echo.
        )
    ) ELSE (
        powershell -Command "Write-Host 'Symbolic link for @LoftDModGR-Clothes-Pack already exists' -ForegroundColor DarkCyan"
        echo.
    )
) ELSE (
    powershell -Command "Write-Host '@LoftDModGR-Clothes-Pack not found in !Workshop folder' -ForegroundColor Red"
    echo.
)

:: Check if the directory "@Survivor Animations" exists
IF EXIST "%WorkshopDir%\@Survivor Animations" (
    powershell -Command "Write-Host 'Found @Survivor Animations' -ForegroundColor Yellow"
    
    :: Create a symbolic link called "@Survivor-Animations" pointing to "@Survivor Animations" if it doesn't already exist
    IF NOT EXIST "%WorkshopDir%\@Survivor-Animations" (
        mklink /J "%WorkshopDir%\@Survivor-Animations" "%WorkshopDir%\@Survivor Animations"
        IF ERRORLEVEL 1 (
            powershell -Command "Write-Host 'Failed to create symbolic link for @Survivor-Animations' -ForegroundColor Red"
            echo.
        ) ELSE (
            powershell -Command "Write-Host 'Symbolic link for @Survivor-Animations created successfully!' -ForegroundColor DarkGreen"
            echo.
        )
    ) ELSE (
        powershell -Command "Write-Host 'Symbolic link for @Survivor-Animations already exists' -ForegroundColor DarkCyan"
        echo.
    )
) ELSE (
    powershell -Command "Write-Host '@Survivor-Animations not found in !Workshop folder' -ForegroundColor Red"
    echo.
)

echo Setup Has Completed!
echo Now go create something awesome!
ENDLOCAL
