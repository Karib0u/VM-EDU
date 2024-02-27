# Define the Desktop path
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define Hayabusa download URL
$hayabusaUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v2.12.0/hayabusa-2.12.0-windows-64-bit.zip"
$hayabusaPath = "$desktopPath\hayabusa-2.12.0-windows-64-bit.zip"

# Download Hayabusa to the Desktop
Invoke-WebRequest -Uri $hayabusaUrl -OutFile $hayabusaPath

# Extract Hayabusa to a folder on the Desktop
$hayabusaExtractPath = "$desktopPath\Hayabusa"
Expand-Archive -LiteralPath $hayabusaPath -DestinationPath $hayabusaExtractPath -Force

# Cleanup the downloaded .zip file
Remove-Item -Path $hayabusaPath -Force

# Navigate to Hayabusa directory and run update-rules
Push-Location -Path $hayabusaExtractPath
Start-Process -FilePath "$hayabusaExtractPath\hayabusa-2.12.0-win-x64.exe" -ArgumentList "update-rules" -Wait
Pop-Location

Write-Output "Hayabusa installation and rules update completed."
