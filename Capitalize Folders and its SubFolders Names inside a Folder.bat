@echo off
setlocal enabledelayedexpansion

echo Converting ALL folders and subfolders to CAPITAL LETTERS...
echo -----------------------------------------------------------

:: This loop finds all subfolders from the deepest layer up to prevent breaking paths
for /f "delims=" %%G in ('dir /b /s /ad ^| sort /r') do (
    set "folderPath=%%~dpG"
    set "oldname=%%~nxG"
    
    :: Convert only the folder name to uppercase using PowerShell
    for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "[regex]::Escape('%%~nxG').ToUpper()"`) do set "newname=%%I"
    
    :: Unescape the string for processing
    for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "[regex]::Unescape('!newname!')"`) do set "finalname=%%I"

    :: Only rename if the uppercase name is structurally different
    if not "!oldname!"=="!finalname!" (
        echo Changing: ".../!oldname!" --^> "!finalname!"
        
        cd /d "!folderPath!"
        rename "!oldname!" "!oldname!_temp"
        rename "!oldname!_temp" "!finalname!"
    )
)

echo -----------------------------------------------------------
echo Done! All deep subfolders processed. Press any key to exit.
pause >nul
