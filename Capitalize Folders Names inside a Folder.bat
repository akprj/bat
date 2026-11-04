@echo off
setlocal enabledelayedexpansion

echo Converting folder names to CAPITAL LETTERS...
echo ------------------------------------------------

for /d %%G in (*) do (
    set "oldname=%%G"
    
    :: Convert the name to uppercase using a built-in loop trick
    for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "'%%G'.ToUpper()"`) do set "newname=%%I"
    
    :: Only rename if the name actually changes
    if not "!oldname!"=="!newname!" (
        echo Changing: "!oldname!" --^> "!newname!"
        
        :: Windows needs a two-step rename to force the case change safely
        rename "%%G" "%%G_temp"
        rename "%%G_temp" "!newname!"
    )
)

echo ------------------------------------------------
echo Done! Press any key to exit.
pause >nul
