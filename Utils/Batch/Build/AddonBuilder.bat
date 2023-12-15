@echo off

set "folder=P:\mods\@DZNC_ServerModZ\Addons"

if not exist "%folder%" (
    mkdir "%folder%"
    echo Folder structure created successfully.
) else (
    echo Folder already exists.
)

SET MakePboPath="C:\Program Files (x86)\Mikero\DePboTools\bin\MakePbo.exe"
SET AddonBuilderPath="C:\Program Files (x86)\Steam\steamapps\common\DayZ Tools\Bin\AddonBuilder\AddonBuilder.exe"

SET ClientSource="P:\ModsClient"
SET ClientOutput="P:\mods\@DZNC_ClientModZ\Addons"

SET ServerSource="P:\ModsServer"
SET ServerOutput="P:\mods\@DZNC_ServerModZ\Addons"

%MakePboPath% %ServerSource% %ServerOutput% 
%AddonBuilderPath% %ClientSource% %ClientOutput% -packonly -clear

powershell -Command "Write-Host 'All mods have been built from the C Drive.' -ForegroundColor DarkCyan"
powershell -Command "Write-Host 'Please Check on your local server to verify.' -ForegroundColor DarkCyan"
pause
