# Define the Desktop path of the current user
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define WinPmem download URL
$winpmemUrl = "https://github.com/Velocidex/WinPmem/releases/download/v4.0.rc1/go-winpmem_amd64_1.0-rc1.exe"
$winpmemFileName = "go-winpmem_amd64_1.0-rc1.exe"
$winpmemPath = Join-Path $desktopPath $winpmemFileName

try {
    # Download WinPmem
    Write-Host "Downloading WinPmem..."
    Invoke-WebRequest -Uri $winpmemUrl -OutFile $winpmemPath

    # Verify the download
    if (Test-Path $winpmemPath) {
        Write-Host "WinPmem downloaded successfully to: $winpmemPath" -ForegroundColor Green
    } else {
        throw "Failed to download WinPmem"
    }
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}