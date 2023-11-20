@echo off

set "folder=P:\mods\@Colorful-UI\Addons"

if not exist "%folder%" (
    mkdir "%folder%"
    echo Folder structure created successfully.
) else (
    echo Folder already exists.
)

SET MakePboPath="C:\Program Files (x86)\Mikero\DePboTools\bin\MakePbo.exe"
SET AddonBuilderPath="C:\Program Files (x86)\Steam\steamapps\common\DayZ Tools\Bin\AddonBuilder\AddonBuilder.exe"

SET ClientSource="P:\Colorful-UI"
SET ClientOutput="P:\mods\@Colorful-UI\Addons"

%AddonBuilderPath% %ClientSource% %ClientOutput% -packonly -clear

powershell -Command "Write-Host 'All mods have been built from the C Drive.' -ForegroundColor DarkCyan"
powershell -Command "Write-Host 'Please Check on your local server to verify.' -ForegroundColor DarkCyan"
pause
