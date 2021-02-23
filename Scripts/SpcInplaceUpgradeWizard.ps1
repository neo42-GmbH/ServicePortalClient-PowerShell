#region Header

$Host.UI.RawUI.BackgroundColor = 'White'
$Host.UI.RawUI.ForegroundColor = 'Black' 
Clear-Host

Write-Output "####################################################################"
Write-Output "#                       neo42 SPC Cmdlet Demo                      #"
Write-Output "#                            Version 3.3                           #"
Write-Output "#                   Copyright(C) 2020 neo42 GmbH                   #"
Write-Output "#                        Visit www.neo42.de                        #"
Write-Output "####################################################################"
Write-Output ""

#endregion

# Description
# This demo script will show you how to create a Windows 10 Inplace Upgrade package.

#region Demo

# Import the SPC module
Import-Module Neo42.Spc.PsModule

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials -ErrorAction Stop
Write-Output "Your email is $($spcCredentials.UserName)" -ErrorAction Stop

# Connect to the portal and create a session object
$spcSession = $null
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Create the Windows 10 Inplace Upgrade package
New-SpcInplaceUpgradePackage -Session $spcSession -WindowsSourceFilesPath "C:\Temp\Win10_20H2_German_x64" -PackageTargetPath "C:\Temp\Win10_Package"

#endregion