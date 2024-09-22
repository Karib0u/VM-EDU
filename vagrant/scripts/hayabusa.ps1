# Define the Desktop path
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define Hayabusa GitHub repository information
$owner = "Yamato-Security"
$repo = "hayabusa"
$apiBaseUrl = "https://api.github.com/repos/$owner/$repo"

# Function to get the latest release information
function Get-LatestRelease {
    $releaseUrl = "$apiBaseUrl/releases/latest"
    $release = Invoke-RestMethod -Uri $releaseUrl -Headers @{
        "Accept" = "application/vnd.github.v3+json"
        "User-Agent" = "PowerShell-HayabusaInstaller"
    }
    return $release
}

# Function to get the appropriate asset for Windows 64-bit
function Get-WindowsAsset($assets) {
    return $assets | Where-Object { 
        $_.name -like "*win-x64.zip" -and 
        $_.name -notlike "*embedded-config*" 
    } | Select-Object -First 1
}

# Main execution
try {
    # Get the latest release
    $latestRelease = Get-LatestRelease
    $asset = Get-WindowsAsset $latestRelease.assets

    if (-not $asset) {
        throw "Could not find appropriate Windows 64-bit release asset."
    }

    # Define Hayabusa download URL and local path
    $hayabusaUrl = $asset.browser_download_url
    $hayabusaFileName = $asset.name
    $hayabusaPath = Join-Path -Path $desktopPath -ChildPath $hayabusaFileName
    $hayabusaExtractPath = Join-Path -Path $desktopPath -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($hayabusaFileName))

    # Download Hayabusa
    Write-Host "Downloading Hayabusa..."
    Invoke-WebRequest -Uri $hayabusaUrl -OutFile $hayabusaPath

    # Extract Hayabusa
    Write-Host "Extracting Hayabusa..."
    Expand-Archive -LiteralPath $hayabusaPath -DestinationPath $hayabusaExtractPath -Force

    # Cleanup the downloaded .zip file
    Remove-Item -Path $hayabusaPath -Force

    # Find the Hayabusa executable
    $hayabusaExe = Get-ChildItem -Path $hayabusaExtractPath -Filter "hayabusa*.exe" | Select-Object -First 1

    if (-not $hayabusaExe) {
        throw "Could not find Hayabusa executable in the extracted folder."
    }

    # Update rules
    Write-Host "Updating Hayabusa rules..."
    Push-Location -Path $hayabusaExtractPath
    $updateProcess = Start-Process -FilePath $hayabusaExe.FullName -ArgumentList "update-rules" -Wait -PassThru -NoNewWindow
    if ($updateProcess.ExitCode -ne 0) {
        throw "Failed to update Hayabusa rules. Exit code: $($updateProcess.ExitCode)"
    }
    Pop-Location

    Write-Host "Hayabusa installation and rules update completed successfully." -ForegroundColor Green
    Write-Host "Installed to: $hayabusaExtractPath"
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
finally {
    if (Test-Path -Path $hayabusaPath) {
        Remove-Item -Path $hayabusaPath -Force
    }
}