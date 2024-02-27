# Define the Desktop path of the current user
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define the MemProcFS download URL and the local file path
$winpmemUrl = "https://github.com/Velocidex/WinPmem/releases/download/v4.0.rc1/winpmem_mini_x64_rc2.exe"
$winpmemPath = "$desktopPath\winpmem_mini_x64_rc2.exe"

# Download MemProcFS to the Desktop
Invoke-WebRequest -Uri $winpmemUrl -OutFile $winpmemPath