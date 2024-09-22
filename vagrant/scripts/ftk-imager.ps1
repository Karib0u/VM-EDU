# Define the Desktop path
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define FTK Imager download information
$ftkUrl = "https://d1kpmuwb7gvu1i.cloudfront.net/AccessData_FTK_Imager_4.7.1.exe"
$ftkFileName = "AccessData_FTK_Imager_4.7.1.exe"

# Function to download file
function Download-File($url, $outputPath) {
    Write-Host "Downloading FTK Imager..."
    Invoke-WebRequest -Uri $url -OutFile $outputPath
}

# Function to install FTK Imager
function Install-FTKImager($installerPath) {
    Write-Host "Installing FTK Imager..."
    $process = Start-Process -FilePath $installerPath -Args "/S" -PassThru -NoNewWindow

    $waitTime = 0
    while ($process.HasExited -eq $false -and $waitTime -lt 120) {
        Start-Sleep -Seconds 10
        $waitTime += 10
    }

    if ($process.HasExited -eq $false) {
        Write-Host "Installation is taking longer than expected. You may need to complete it manually." -ForegroundColor Yellow
        return $false
    }

    return $true
}

# Main execution
try {
    # Define local paths
    $localFilePath = Join-Path -Path $desktopPath -ChildPath $ftkFileName

    # Download FTK Imager
    Download-File -url $ftkUrl -outputPath $localFilePath

    # Install FTK Imager
    $installationSuccess = Install-FTKImager -installerPath $localFilePath

    if ($installationSuccess) {
        Write-Host "FTK Imager installation completed successfully." -ForegroundColor Green
    } else {
        Write-Host "FTK Imager installation may not have completed. Please check manually." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
finally {
    # Cleanup the downloaded installer
    if (Test-Path -Path $localFilePath) {
        Remove-Item -Path $localFilePath -Force
        Write-Host "Cleaned up installer file."
    }
}