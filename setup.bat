@echo off
title EncryptCo Setup Installer
color 0A

:: ================================
:: CONFIGURATION
:: ================================
set "SCRIPT_NAME=main.py"
set "SHORTCUT_NAME=EncryptCo Suite"

cls
echo ================================
echo         ENCRYPTCO SETUP
echo ================================
echo.

echo Checking Python installation...
timeout /t 1 >nul

:: Check Python (py launcher)
py --version >nul 2>&1
if %errorlevel%==0 goto install_deps

:: Check python command
python --version >nul 2>&1
if %errorlevel%==0 goto install_deps

:: Not found → launch installer
echo.
echo [!] Python not found
echo [→] Launching Python installer...

start "" "%~dp0python_installer.exe"

echo.
echo We're installing the Python software for you so you can use the app.
echo When it finishes, press any key to continue the installer.
pause >nul

goto check

:: ================================
:: RE-CHECK LOOP
:: ================================
:check
py --version >nul 2>&1
if %errorlevel%==0 goto install_deps

python --version >nul 2>&1
if %errorlevel%==0 goto install_deps

echo.
echo We still couldn't detect Python on your system. You can try again, or manually install Python from:
echo https://apps.microsoft.com/detail/9ncvdn91xzqp?hl=en-GB&gl=AU
echo Please finish installation, then press any key to try again.
pause >nul
goto check

:: ================================
:: INSTALL DEPENDENCIES
:: ================================
:install_deps
echo.
echo Installing required packages (customtkinter)...
py -m pip install customtkinter >nul 2>&1
if %errorlevel%==0 goto create_shortcuts

python -m pip install customtkinter >nul 2>&1
if %errorlevel%==0 goto create_shortcuts

echo [!] Pip failed. Trying alternative install setup...
pip install customtkinter >nul 2>&1

:: ================================
:: CREATE DESKTOP SHORTCUTS
:: ================================
:create_shortcuts
echo.
echo Creating Desktop shortcuts...

:: Target pathways
set "TARGET_PATH=%~dp0%SCRIPT_NAME%"
set "VBS_SCRIPT=%TEMP%\CreateShortcut.vbs"

:: Determine python executable to run the shortcut with
set "PYTHON_EXE=pythonw"
py --version >nul 2>&1 && set "PYTHON_EXE=pyw"

:: Create VBScript generator for standard Local Desktop
if exist "%USERPROFILE%\Desktop" (
    echo Set oWS = WScript.CreateObject^("WScript.Shell"^) > "%VBS_SCRIPT%"
    echo sLinkFile = "%USERPROFILE%\Desktop\%SHORTCUT_NAME%.lnk" >> "%VBS_SCRIPT%"
    echo Set oLink = oWS.CreateShortcut^(sLinkFile^) >> "%VBS_SCRIPT%"
    echo oLink.TargetPath = "%PYTHON_EXE%" >> "%VBS_SCRIPT%"
    echo oLink.Arguments = """%TARGET_PATH%""" >> "%VBS_SCRIPT%"
    echo oLink.WorkingDirectory = "%~dp0" >> "%VBS_SCRIPT%"
    echo oLink.Save >> "%VBS_SCRIPT%"
    cscript /nologo "%VBS_SCRIPT%" >nul 2>&1
)

:: Create VBScript generator for OneDrive Desktop
if exist "%USERPROFILE%\OneDrive\Desktop" (
    echo Set oWS = WScript.CreateObject^("WScript.Shell"^) > "%VBS_SCRIPT%"
    echo sLinkFile = "%USERPROFILE%\OneDrive\Desktop\%SHORTCUT_NAME%.lnk" >> "%VBS_SCRIPT%"
    echo Set oLink = oWS.CreateShortcut^(sLinkFile^) >> "%VBS_SCRIPT%"
    echo oLink.TargetPath = "%PYTHON_EXE%" >> "%VBS_SCRIPT%"
    echo oLink.Arguments = """%TARGET_PATH%""" >> "%VBS_SCRIPT%"
    echo oLink.WorkingDirectory = "%~dp0" >> "%VBS_SCRIPT%"
    echo oLink.Save >> "%VBS_SCRIPT%"
    cscript /nologo "%VBS_SCRIPT%" >nul 2>&1
)

:: Clean up temporary VBScript
if exist "%VBS_SCRIPT%" del "%VBS_SCRIPT%"

:: ================================
:: READY STATE & LAUNCH
:: ================================
:ready
cls
echo ================================
echo         ENCRYPTCO SETUP
echo ================================
echo.
echo [✔] Python detected
echo [✔] CustomTkinter installed
echo [✔] Desktop shortcuts updated
echo [✔] Setup complete!
echo.
echo Launching application...
timeout /t 2 >nul

:: Launch using pythonw/pyw to suppress the messy cmd window background
start "" %PYTHON_EXE% "%TARGET_PATH%"
exit