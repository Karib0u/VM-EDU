# Define the Desktop path
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define Zircolite download URL
$zircoliteUrl = "https://github.com/wagga40/Zircolite/releases/download/2.10.0/zircolite_win10_x64_2.10.0.7z"
$zircolitePath = "$desktopPath\zircolite_win10_x64_2.10.0.7z"

# Download Zircolite to the Desktop
Invoke-WebRequest -Uri $zircoliteUrl -OutFile $zircolitePath

# Assuming 7-Zip is installed and available in PATH
# Extract Zircolite to a folder on the Desktop
$zircoliteExtractPath = "$desktopPath"
New-Item -ItemType Directory -Force -Path $zircoliteExtractPath
# Extract Zircolite to a folder on the Desktop, automatically overwrite existing files
& 7z x $zircolitePath "-o$zircoliteExtractPath" -aoa

# Cleanup the downloaded .7z file
Remove-Item -Path $zircolitePath -Force

Write-Output "Zircolite installation completed."
