# Define the Desktop path of the current user
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define the MemProcFS download URL and the local file path
$memprocfsUrl = "https://github.com/ufrisk/MemProcFS/releases/download/v5.8/MemProcFS_files_and_binaries_v5.8.25-win_x64-20240207.zip"
$memprocfsPath = "$desktopPath\MemProcFS.zip"

# Download MemProcFS to the Desktop
Invoke-WebRequest -Uri $memprocfsUrl -OutFile $memprocfsPath

# Extract MemProcFS to a folder on the Desktop
$memprocfsExtractPath = "$desktopPath\MemProcFS"
Expand-Archive -LiteralPath $memprocfsPath -DestinationPath $memprocfsExtractPath -Force

# Cleanup the downloaded zip file
Remove-Item -Path $memprocfsPath -Force

# Download and install Dokany (adjust the download URL as needed for the latest version)
$dokanSetupUrl = "https://github.com/dokan-dev/dokany/releases/latest/download/Dokan_x64.msi"
$dokanSetupPath = "$desktopPath\DokanSetup.msi"
Invoke-WebRequest -Uri $dokanSetupUrl -OutFile $dokanSetupPath

# Install Dokany
Start-Process msiexec.exe -ArgumentList "/i $dokanSetupPath /quiet" -Wait

# Optionally, remove the Dokany installer after installation
Remove-Item -Path $dokanSetupPath -Force