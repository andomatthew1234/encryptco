@echo off
setlocal EnableDelayedExpansion
title EncryptCo Release Installer
color 0A

:: ===============================
:: CONFIG
:: ===============================
set "INSTALL_DIR=%USERPROFILE%\EncryptCo"
set "ZIP_FILE=%TEMP%\encryptco_release.zip"
set "EXTRACT_DIR=%USERPROFILE%\EncryptCo"

:: Your GitHub Releases ZIP (EDITED TO MATCH YOUR LINK)
set "URL=https://github.com/andomatthew1234/encryptco/releases/latest/download/encryptco.zip"

:: ===============================
:: HEADER
:: ===============================
cls
echo ==========================================
echo            ENCRYPTCO INSTALLER
echo ==========================================
echo.
echo Downloading latest release...
echo.

:: ===============================
:: DOWNLOAD RELEASE
:: ===============================
powershell -Command ^
"Invoke-WebRequest -Uri '%URL%' -OutFile '%ZIP_FILE%'"

if not exist "%ZIP_FILE%" (
    echo ❌ We couldn't find the release file. Please check your internet connection and try again.
    pause
    exit
)

echo ✔ Download complete
echo.
echo Extracting files...

:: ===============================
:: EXTRACT ZIP
:: ===============================
powershell -Command ^
"Expand-Archive -Force '%ZIP_FILE%' '%EXTRACT_DIR%'"

if %errorlevel% neq 0 (
    echo ❌ We couldn't extract the release file. Please check the ZIP file and try again.
    pause
    exit
)

echo ✔ Extraction of Encrypto complete
echo.

:: ===============================
:: FIND EXTRACTED FOLDER (GitHub creates folder name)
:: ===============================
for /d %%F in ("%EXTRACT_DIR%\*") do (
    set "APP_DIR=%%F"
    goto found
)

:found
cd /d "%APP_DIR%"

echo → Starting setup...
echo.

if exist setup.bat (
    call setup.bat
) else (
    echo ❌ Error: setup.bat file not found
)

echo.
echo ==========================================
echo Setup complete.
echo ==========================================
pause
exit