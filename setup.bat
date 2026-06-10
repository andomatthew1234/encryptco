@echo off
title EncryptCo Setup Installer
color 0A

cls
echo ================================
echo        ENCRYPTCO SETUP
echo ================================
echo.

echo Checking Python installation...
timeout /t 1 >nul

:: Check Python (py launcher)
py --version >nul 2>&1
if %errorlevel%==0 goto ready

:: Check python command
python --version >nul 2>&1
if %errorlevel%==0 goto ready

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
if %errorlevel%==0 goto ready

python --version >nul 2>&1
if %errorlevel%==0 goto ready

echo.
echo We still couldn't detect Python on your system. You can try again, or manually install Python from:
echo https://apps.microsoft.com/detail/9ncvdn91xzqp?hl=en-GB&gl=AU
echo Please finish installation, then press any key to try again.
pause >nul
goto check

:: ================================
:: READY STATE
:: ================================
:ready
cls
echo ================================
echo        ENCRYPTCO SETUP
echo ================================
echo.
echo [✔] Python detected
echo [✔] Setup complete
echo [✔] Ready to run EncryptCo
echo.
pause
exit