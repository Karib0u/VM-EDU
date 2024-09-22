@echo off
setlocal enabledelayedexpansion

:: Define variables
set "TEMP_DIR=C:\Windows\Temp"
set "SEVEN_ZIP_MSI=%TEMP_DIR%\7z2408-x64.msi"
set "SEVEN_ZIP_URL=https://7-zip.org/a/7z2408-x64.msi"
set "SEVEN_ZIP_EXE=C:\Program Files\7-Zip\7z.exe"

:: Install 7-Zip
call :install_7zip

:: Process based on builder type
if "%PACKER_BUILDER_TYPE%"=="vmware-iso" (
    call :process_vmware
) else if "%PACKER_BUILDER_TYPE%"=="virtualbox-iso" (
    call :process_virtualbox
) else if "%PACKER_BUILDER_TYPE%"=="parallels-iso" (
    call :process_parallels
)

:: Uninstall 7-Zip
msiexec /qb /x "%SEVEN_ZIP_MSI%"

goto :eof

:install_7zip
:: Download and install 7-Zip
call :download_file "%SEVEN_ZIP_URL%" "%SEVEN_ZIP_MSI%"
if not exist "%SEVEN_ZIP_MSI%" (
    echo Failed to download 7-Zip. Exiting.
    exit /b 1
)
msiexec /qb /i "%SEVEN_ZIP_MSI%"
exit /b 0

:download_file
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%~1', '%~2')" <NUL
if not exist "%~2" (
    powershell -Command "Start-Sleep 5 ; (New-Object System.Net.WebClient).DownloadFile('%~1', '%~2')" <NUL
)
exit /b 0

:process_vmware
set "VMWARE_TOOLS_DIR=%TEMP_DIR%\VMwareTools"
set "VMWARE_TOOLS_URL=https://packages.vmware.com/tools/releases/latest/windows/x64/"

if not exist "%VMWARE_TOOLS_DIR%" mkdir "%VMWARE_TOOLS_DIR%"

powershell -Command "$ProgressPreference = 'SilentlyContinue'; $html = Invoke-WebRequest -Uri '%VMWARE_TOOLS_URL%' -UseBasicParsing; $link = $html.Links | Where-Object { $_.href -like '*x86_64.exe' } | Select-Object -First 1 -ExpandProperty href; Invoke-WebRequest -Uri ('%VMWARE_TOOLS_URL%' + $link) -OutFile '%VMWARE_TOOLS_DIR%\VMwareTools.exe'"

if not exist "%VMWARE_TOOLS_DIR%\VMwareTools.exe" (
    echo Failed to download VMware Tools. Exiting.
    exit /b 1
)

"%VMWARE_TOOLS_DIR%\VMwareTools.exe" /S /v"/qn REBOOT=R\"

del /Q "%VMWARE_TOOLS_DIR%\VMwareTools.exe"
rd /S /Q "%VMWARE_TOOLS_DIR%"
exit /b 0

:process_virtualbox
set "VBOX_ISO=%TEMP_DIR%\VBoxGuestAdditions.iso"
set "VBOX_URL=https://download.virtualbox.org/virtualbox/7.0.20/VBoxGuestAdditions_7.0.20.iso"

if exist "C:\Users\vagrant\VBoxGuestAdditions.iso" move /Y "C:\Users\vagrant\VBoxGuestAdditions.iso" "%TEMP_DIR%"

if not exist "%VBOX_ISO%" call :download_file "%VBOX_URL%" "%VBOX_ISO%"

"%SEVEN_ZIP_EXE%" x "%VBOX_ISO%" -o"%TEMP_DIR%\virtualbox"
for %%i in (%TEMP_DIR%\virtualbox\cert\vbox*.cer) do "%TEMP_DIR%\virtualbox\cert\VBoxCertUtil" add-trusted-publisher %%i --root %%i
"%TEMP_DIR%\virtualbox\VBoxWindowsAdditions.exe" /S
rd /S /Q "%TEMP_DIR%\virtualbox"
exit /b 0

:process_parallels
set "PARALLELS_ISO=%TEMP_DIR%\prl-tools-win.iso"

if exist "C:\Users\vagrant\prl-tools-win.iso" (
    move /Y "C:\Users\vagrant\prl-tools-win.iso" "%PARALLELS_ISO%"
    "%SEVEN_ZIP_EXE%" x "%PARALLELS_ISO%" -o"%TEMP_DIR%\parallels"
    "%TEMP_DIR%\parallels\PTAgent.exe" /install_silent
    rd /S /Q "%TEMP_DIR%\parallels"
)
exit /b 0