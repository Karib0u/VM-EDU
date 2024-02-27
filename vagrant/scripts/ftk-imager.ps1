# Define the URL and the local file path
$url = "https://d1kpmuwb7gvu1i.cloudfront.net/AccessData_FTK_Imager_4.7.1.exe"
$localFilePath = "C:\Temp\AccessData_FTK_Imager_4.7.1.exe"

# Create the directory if it doesn't exist
$localDir = Split-Path -Path $localFilePath -Parent
If (-not (Test-Path -Path $localDir)) {
    New-Item -ItemType Directory -Path $localDir
}

# Download the file
Invoke-WebRequest -Uri $url -OutFile $localFilePath

# Start the installation process
$process = Start-Process -FilePath $localFilePath -Args "/S" -PassThru -NoNewWindow

# Wait for the process to exit (or a maximum of 2 minutes)
$waitTime = 0
while ($process.HasExited -eq $false -and $waitTime -lt 120) {
    Start-Sleep -Seconds 10
    $waitTime += 10
}

# Optional: Kill the process if it never exits (not recommended without knowing the consequences)
if ($process.HasExited -eq $false) {
    $process | Stop-Process -Force
}
