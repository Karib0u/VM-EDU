
		#-------------------------------------------------------------------------------------------------#
		# 	The applications removed by this script can be restored by following the procedure below: #
		#												  #
		# 	New-Item C:\Mnt -Type Directory | Out-Null					          #
		# 	dism /Mount-Image /ImageFile:D:\sources\install.wim /index:1 /ReadOnly /MountDir:C:\Mnt	  #
		# 	robocopy /S /SEC /R:0 "C:\Mnt\Program Files\WindowsApps" "C:\Program Files\WindowsApps"	  #
		# 	dism /Unmount-Image /Discard /MountDir:C:\Mnt						  #
		# 	Remove-Item -Path C:\Mnt -Recurse							  #
		#												  #
		#-------------------------------------------------------------------------------------------------#

$tweaks = @(

	"debloatWindows"
	"removeXBOX"
    "removeExtraFeatures"
)

Function debloatWindows {
	Clear-Host
	$Bloatware = @(
		#Unnecessary Windows 10 AppX Apps
		"*3DBuilder*"
		"*AppConnector*"
        	"*BingWeather*"
		"*BingFinance*"
		"*BingNews*"
		"*BingSports*"
		"*BingTranslator*"
		"*GetHelp*"
		"*Getstarted*"
		"*Messaging*"
		"*Microsoft3DViewer*"
		"*MicrosoftSolitaireCollection*"
		"*MicrosoftPowerBIForWindows*"
		"*MicrosoftStickyNotes*"
        	"*Microsoft.MicrosoftOfficeHub*" #Get Office
        	"*Microsoft.Office.OneNote*"
        	"*Microsoft.Office.Sway*"
        	"*Microsoft.Windows.Photos*" 
        	"*Microsoft.WindowsCamera*" 
        	"*Microsoft.WindowsCommunicationsApps*" #Microsoft Mail & Calendar Application
        	"*Microsoft.WindowsStore*" 
        	"*Microsoft.ZuneMusic*" #Groove Music
        	"*Microsoft.ZuneVideo*" #Movies & TV
		"*NetworkSpeedTest*"
		"*Lens*"
		"*OneConnect*"
		"*People*"
		"*Print3D*"
		"*SkypeApp*"
		"*Wallet*"
		"*Whiteboard*"
		"*WindowsAlarms*"
		"*WindowsFeedbackHub*"
		"*WindowsMaps*"
		"*WindowsPhone*"
		"*WindowsSoundRecorder*"
		"*MixedReality.Portal*"
		"*Microsoft.MSPaint*"
		"*Microsoft.549981C3F5F10*"
		"*Advertising.Xaml*"
		"*SolitaireCollection*"
		"*YourPhone*"

		#Sponsored Windows 10 AppX Apps (add sponsored/featured apps to remove in the "*AppName*" format!)
		
		"*EclipseManager*"
		"*ActiproSoftwareLLC*"
		"*AdobePhotoshopExpress*"
		"*Duolingo-LearnLanguagesforFree*"
		"*PandoraMediaInc*"
		"*CandyCrush*"
		"*BubbleWitch3Saga*"
		"*Wunderlist*"
		"*Flipboard*"
		"*Twitter*"
		"*Facebook*"
		"*Royal Revolt*"
		"*Sway*"
		"*Speed Test*"
		"*Viber*"
		"*ACGMediaPlayer*"
		"*Netflix*"
		"*OneCalendar*"
		"*LinkedInforWindows*"
		"*HiddenCityMysteryofShadows*"
		"*Hulu*"
		"*HiddenCity*"
		"*AdobePhotoshopExpress*"
		"*RoyalRevolt2*"
		"*AutodeskSketchBook*"
		"*DisneyMagicKingdoms*"
		"*MarchofEmpires*"
		"*Plex*"
		"*FarmVille2CountryEscape*"
		"*CyberLinkMediaSuiteEssentials*"
		"*DrawboardPDF*"
		"*Asphalt8Airborne*"
		"*WinZipUniversal*"
		"*XING*"           
		"*Advertising.Xaml*"
		"*Advertising.Xaml*"
		"*Roblox*"
	)
	
	foreach ($Bloat in $Bloatware) {

		$errpref = $ErrorActionPreference #save actual preference
		$ErrorActionPreference = "silentlycontinue"

		Get-AppxPackage -AllUsers -Name $Bloat | Remove-AppxPackage | Out-Null -ErrorAction SilentlyContinue
		Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like $Bloat | Remove-AppxProvisionedPackage -Online | Out-Null -ErrorAction SilentlyContinue

		$ErrorActionPreference = $errpref #restore previous preference

		Write-Output "Trying to remove $Bloat."
	}
}

#Remove Uneeded Windows Features

Function removeExtraFeatures {

    $errpref = $ErrorActionPreference #save actual preference
    $ErrorActionPreference = "silentlycontinue"

    #Remove PowerShellv2 from Target

    Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -NoRestart

    #Kill and Uninstall "OneDrive"

    taskkill.exe /F /IM "OneDrive.exe"
    taskkill.exe /F /IM "explorer.exe"

    start-process "$env:windir\SysWOW64\OneDriveSetup.exe" "/uninstall"

    #Remove OneDrive leftovers

    rm -Recurse -Force "$env:localappdata\Microsoft\OneDrive"
    rm -Recurse -Force "$env:programdata\Microsoft OneDrive"
    rm -Recurse -Force "C:\OneDriveTemp"

    #Remove Onedrive from explorer sidebar

    New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
    mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    sp "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
    mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    sp "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
    Remove-PSDrive "HKCR"

    #Remove run option for new users

    reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
    reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
    reg unload "hku\Default"

    #Remove startmenu junk entry

    rm -Force "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

    #Restart explorer...

    start "explorer.exe"

    #Remove Microsoft Office Click-to-Run executable

    $OfficeUninstallStrings = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where {$_.DisplayName -like "*Microsoft Office*"} | Select UninstallString).UninstallString

    ForEach ($UninstallString in $OfficeUninstallStrings) {
        $UninstallEXE = ($UninstallString -split '"')[1]
        $UninstallArg = ($UninstallString -split '"')[2] + " DisplayLevel=False"
        Start-Process -FilePath $UninstallEXE -ArgumentList $UninstallArg -Wait -Verb RunAs
    } 
}

#Disable and Remove Xbox Related Apps

Function removeXBOX {
    
    $errpref = $ErrorActionPreference #Save Actual Preference
    $ErrorActionPreference = "silentlycontinue"

    Write-Output "Disabling Xbox features..."
    Get-AppxPackage -AllUsers "*Microsoft.XboxApp*" | Remove-AppxPackage
    Get-AppxPackage -AllUsers "*Microsoft.XboxIdentityProvider*" | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxPackage -AllUsers "*Microsoft.XboxSpeechToTextOverlay*" | Remove-AppxPackage
    Get-AppxPackage -AllUsers "*Microsoft.XboxGamingOverlay*" | Remove-AppxPackage
    Get-AppxPackage -AllUsers "*Microsoft.Xbox.TCUI*" | Remove-AppxPackage
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0

    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
    	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
    }
    
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0

    $ErrorActionPreference = $errpref #Restore Previous Preference

    Clear-Host
}

#Normalize path to preset file

$preset = ""
$PSCommandArgs = $args

If ($args -And $args[0].ToLower() -eq "-preset") {
	$preset = Resolve-Path $($args | Select-Object -Skip 1)
	$PSCommandArgs = "-preset `"$preset`""
}

#Load function names from command line arguments or a preset file

If ($args) {
	$tweaks = $args
	If ($preset) {
		$tweaks = Get-Content $preset -ErrorAction Stop | foreach { $_.Trim() } | where { $_ -ne "" -and $_[0] -ne "#" }
	}
}

#Call applicable "tweak" functions

$tweaks | foreach { Invoke-Expression $_ }