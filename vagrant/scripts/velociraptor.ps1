# Define the Desktop path of the current user
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define Velociraptor GitHub repository information
$owner = "Velocidex"
$repo = "velociraptor"
$apiBaseUrl = "https://api.github.com/repos/$owner/$repo"

# Function to get the latest release information
function Get-LatestRelease {
    $releaseUrl = "$apiBaseUrl/releases/latest"
    $release = Invoke-RestMethod -Uri $releaseUrl -Headers @{
        "Accept" = "application/vnd.github.v3+json"
        "User-Agent" = "PowerShell-VelociraptorInstaller"
    }
    return $release
}

# Function to get the appropriate asset for Windows 64-bit
function Get-WindowsAsset($assets) {
    return $assets | Where-Object { 
        $_.name -like "*windows-amd64.exe" 
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

    # Define Velociraptor download URL and local path
    $velociraptorUrl = $asset.browser_download_url
    $velociraptorFileName = $asset.name
    $velociraptorPath = Join-Path -Path $desktopPath -ChildPath $velociraptorFileName

    # Download Velociraptor
    Write-Host "Downloading Velociraptor..."
    Invoke-WebRequest -Uri $velociraptorUrl -OutFile $velociraptorPath

    Write-Host "Velociraptor download completed successfully." -ForegroundColor Green
    Write-Host "Velociraptor executable downloaded to: $velociraptorPath"

    # Optionally, you can add steps here to create a shortcut or move the executable to a specific location

}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}