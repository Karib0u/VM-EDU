# Define the Desktop path of the current user
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Define the MemProcFS download URL and the local file path
$velociraptorUrl = "https://github.com/Velocidex/velociraptor/releases/download/v0.7.1/velociraptor-v0.7.1-1-windows-amd64.exe"
$velociraptorPath = "$desktopPath\velociraptor-v0.7.1-1-windows-amd64.exe"

# Download MemProcFS to the Desktop
Invoke-WebRequest -Uri $velociraptorUrl -OutFile $velociraptorPath