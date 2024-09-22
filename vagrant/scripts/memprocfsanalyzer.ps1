# Define the GitHub repository information
$owner = "evild3ad"
$repo = "MemProcFS-Analyzer"
$apiBaseUrl = "https://api.github.com/repos/$owner/$repo"

# Function to get the latest release information
function Get-LatestRelease {
    $releaseUrl = "$apiBaseUrl/releases/latest"
    $release = Invoke-RestMethod -Uri $releaseUrl -Headers @{
        "Accept" = "application/vnd.github.v3+json"
        "User-Agent" = "PowerShell-MemProcFSAnalyzerInstaller"
    }
    return $release
}

# Function to get the appropriate asset
function Get-Asset($assets) {
    return $assets | Where-Object { 
        $_.name -like "MemProcFS-Analyzer-*.zip" 
    } | Select-Object -First 1
}

# Main execution
try {
    # Get the latest release
    $latestRelease = Get-LatestRelease
    $asset = Get-Asset $latestRelease.assets

    if (-not $asset) {
        throw "Could not find appropriate MemProcFS-Analyzer release asset."
    }

    # Define download URL and local paths
    $downloadUrl = $asset.browser_download_url
    $zipFileName = $asset.name
    $desktopPath = [System.Environment]::GetFolderPath("Desktop")
    $downloadPath = Join-Path -Path $desktopPath -ChildPath $zipFileName

    # Download MemProcFS-Analyzer
    Write-Host "Downloading MemProcFS-Analyzer..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

    # Extract the zip file directly to the desktop
    Write-Host "Extracting MemProcFS-Analyzer..."
    Expand-Archive -Path $downloadPath -DestinationPath $desktopPath -Force

    # Get the actual directory name (including the version number)
    $extractedDir = Get-ChildItem -Path $desktopPath -Directory | Where-Object { $_.Name -like "MemProcFS-Analyzer*" } | Select-Object -First 1
    $actualExtractPath = $extractedDir.FullName

    # Run the Updater.ps1 script
    $updaterPath = Join-Path -Path $actualExtractPath -ChildPath "Updater.ps1"
    if (Test-Path $updaterPath) {
        Write-Host "Running Updater.ps1..."
        & $updaterPath
    } else {
        Write-Host "Updater.ps1 not found. Skipping update process." -ForegroundColor Yellow
    }

    Write-Host "MemProcFS-Analyzer installation and update completed successfully." -ForegroundColor Green
    Write-Host "MemProcFS-Analyzer installed to: $actualExtractPath"
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
finally {
    # Cleanup the downloaded zip file
    if (Test-Path -Path $downloadPath) {
        Remove-Item -Path $downloadPath -Force
        Write-Host "Cleaned up downloaded zip file."
    }
}