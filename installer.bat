@echo off
setlocal EnableDelayedExpansion

title EncryptCo Installer
color 0A

:: ==========================
:: CONFIG
:: ==========================
set "INSTALL_DIR=%USERPROFILE%\EncryptCo"
set "ZIP_FILE=%TEMP%\encryptco_release.zip"

:: CHANGE THIS TO YOUR ACTUAL RELEASE ASSET
set "URL=https://github.com/andomatthew1234/encryptco/releases/latest/download/encryptco.zip"

cls
echo ==========================================
echo           ENCRYPTCO INSTALLER
echo ==========================================
echo.
echo Downloading latest release...
echo.

:: ==========================
:: DOWNLOAD
:: ==========================
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%ZIP_FILE%'"

if not exist "%ZIP_FILE%" (
    echo.
    echo [ERROR] Download failed.
    pause
    exit /b
)

echo [OK] Download complete.
echo.

:: ==========================
:: CLEAN OLD INSTALL
:: ==========================
if exist "%INSTALL_DIR%" (
    echo Removing previous installation...
    rmdir /s /q "%INSTALL_DIR%"
)

mkdir "%INSTALL_DIR%"

:: ==========================
:: EXTRACT
:: ==========================
echo Extracting files...

powershell -Command "Expand-Archive -Force '%ZIP_FILE%' '%INSTALL_DIR%'"

if errorlevel 1 (
    echo.
    echo [ERROR] Extraction failed.
    pause
    exit /b
)

echo [OK] Extraction complete.
echo.

:: ==========================
:: FIND setup.bat
:: ==========================
echo Searching for setup.bat...
set "FOUND="

for /r "%INSTALL_DIR%" %%F in (setup.bat) do (
    set "FOUND=%%F"
    goto launch
)

echo.
echo [ERROR] setup.bat was not found.
echo.
echo Make sure your GitHub Release ZIP contains:
echo.
echo     setup.bat
echo     run.bat
echo     app.py
echo.
pause
exit /b

:: ==========================
:: RUN SETUP
:: ==========================
:launch

echo [OK] Found setup.bat
echo [INFO] Starting setup...
echo.

cd /d "%~dp0"

call "!FOUND!"

echo.
echo ==========================================
echo Setup complete.
echo ==========================================
pause
exit