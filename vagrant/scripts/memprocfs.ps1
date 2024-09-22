# Define the Desktop path of the current user
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define MemProcFS and Dokany GitHub repository information
$memprocfsOwner = "ufrisk"
$memprocfsRepo = "MemProcFS"
$dokanyOwner = "dokan-dev"
$dokanyRepo = "dokany"
$apiBaseUrl = "https://api.github.com/repos"

# Function to get the latest release information
function Get-LatestRelease($owner, $repo) {
    $releaseUrl = "$apiBaseUrl/$owner/$repo/releases/latest"
    $release = Invoke-RestMethod -Uri $releaseUrl -Headers @{
        "Accept" = "application/vnd.github.v3+json"
        "User-Agent" = "PowerShell-MemProcFSInstaller"
    }
    return $release
}

# Function to get the appropriate asset
function Get-Asset($assets, $pattern) {
    return $assets | Where-Object { $_.name -like $pattern } | Select-Object -First 1
}

# Main execution
try {
    # Get the latest MemProcFS release
    $memprocfsRelease = Get-LatestRelease $memprocfsOwner $memprocfsRepo
    $memprocfsAsset = Get-Asset $memprocfsRelease.assets "*win_x64*.zip"

    if (-not $memprocfsAsset) {
        throw "Could not find appropriate MemProcFS Windows 64-bit release asset."
    }

    # Define MemProcFS download URL and local path
    $memprocfsUrl = $memprocfsAsset.browser_download_url
    $memprocfsFileName = $memprocfsAsset.name
    $memprocfsPath = Join-Path -Path $desktopPath -ChildPath $memprocfsFileName
    $memprocfsExtractPath = Join-Path -Path $desktopPath -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($memprocfsFileName))

    # Download MemProcFS
    Write-Host "Downloading MemProcFS..."
    Invoke-WebRequest -Uri $memprocfsUrl -OutFile $memprocfsPath

    # Extract MemProcFS
    Write-Host "Extracting MemProcFS..."
    Expand-Archive -LiteralPath $memprocfsPath -DestinationPath $memprocfsExtractPath -Force

    # Cleanup the downloaded .zip file
    Remove-Item -Path $memprocfsPath -Force

    # Get the latest Dokany release
    $dokanyRelease = Get-LatestRelease $dokanyOwner $dokanyRepo
    $dokanyAsset = Get-Asset $dokanyRelease.assets "Dokan_x64.msi"

    if (-not $dokanyAsset) {
        throw "Could not find appropriate Dokany Windows 64-bit release asset."
    }

    # Define Dokany download URL and local path
    $dokanSetupUrl = $dokanyAsset.browser_download_url
    $dokanSetupPath = Join-Path -Path $desktopPath -ChildPath "DokanSetup.msi"

    # Download Dokany
    Write-Host "Downloading Dokany..."
    Invoke-WebRequest -Uri $dokanSetupUrl -OutFile $dokanSetupPath

    # Install Dokany
    Write-Host "Installing Dokany..."
    $installProcess = Start-Process msiexec.exe -ArgumentList "/i `"$dokanSetupPath`" /quiet" -Wait -PassThru
    if ($installProcess.ExitCode -ne 0) {
        throw "Failed to install Dokany. Exit code: $($installProcess.ExitCode)"
    }

    Write-Host "MemProcFS and Dokany installation completed successfully." -ForegroundColor Green
    Write-Host "MemProcFS installed to: $memprocfsExtractPath"
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
finally {
    # Cleanup
    if (Test-Path -Path $memprocfsPath) {
        Remove-Item -Path $memprocfsPath -Force
    }
    if (Test-Path -Path $dokanSetupPath) {
        Remove-Item -Path $dokanSetupPath -Force
    }
}