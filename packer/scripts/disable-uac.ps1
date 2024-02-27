# Disable User Account Control (UAC)
Write-Host "Disabling User Account Control (UAC)..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
