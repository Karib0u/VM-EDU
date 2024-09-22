# Define the Desktop path
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define Zircolite GitHub repository information
$owner = "wagga40"
$repo = "Zircolite"
$apiBaseUrl = "https://api.github.com/repos/$owner/$repo"

# Function to get the latest release information
function Get-LatestRelease {
    $releaseUrl = "$apiBaseUrl/releases/latest"
    $release = Invoke-RestMethod -Uri $releaseUrl -Headers @{
        "Accept" = "application/vnd.github.v3+json"
        "User-Agent" = "PowerShell-ZircoliteInstaller"
    }
    return $release
}

# Function to get the appropriate asset for Windows 64-bit
function Get-WindowsAsset($assets) {
    return $assets | Where-Object { 
        $_.name -like "*win*.7z" 
    } | Select-Object -First 1
}

# Function to check if 7-Zip is installed
function Test-7Zip {
    try {
        $null = Get-Command 7z -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Main execution
try {
    # Check if 7-Zip is installed
    if (-not (Test-7Zip)) {
        throw "7-Zip is not installed or not in PATH. Please install 7-Zip and add it to your PATH."
    }

    # Get the latest release
    $latestRelease = Get-LatestRelease
    $asset = Get-WindowsAsset $latestRelease.assets

    if (-not $asset) {
        throw "Could not find appropriate Windows 64-bit release asset."
    }

    # Define Zircolite download URL and local path
    $zircoliteUrl = $asset.browser_download_url
    $zircoliteFileName = $asset.name
    $zircolitePath = Join-Path -Path $desktopPath -ChildPath $zircoliteFileName
    $zircoliteExtractPath = Join-Path -Path $desktopPath -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($zircoliteFileName))

    # Download Zircolite
    Write-Host "Downloading Zircolite..."
    Invoke-WebRequest -Uri $zircoliteUrl -OutFile $zircolitePath

    # Extract Zircolite
    Write-Host "Extracting Zircolite..."
    $extractProcess = Start-Process -FilePath "7z" -ArgumentList "x", $zircolitePath, "-o$zircoliteExtractPath", "-aoa" -NoNewWindow -PassThru -Wait
    if ($extractProcess.ExitCode -ne 0) {
        throw "Failed to extract Zircolite. Exit code: $($extractProcess.ExitCode)"
    }

    Write-Host "Zircolite installation completed successfully." -ForegroundColor Green
    Write-Host "Zircolite extracted to: $zircoliteExtractPath"
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
finally {
    # Cleanup the downloaded .7z file
    if (Test-Path -Path $zircolitePath) {
        Remove-Item -Path $zircolitePath -Force
    }
}