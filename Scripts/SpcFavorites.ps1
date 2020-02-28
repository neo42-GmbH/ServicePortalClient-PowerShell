#region Header

$Host.UI.RawUI.BackgroundColor = 'White'
$Host.UI.RawUI.ForegroundColor = 'Black' 
cls

Write-Output "####################################################################"
Write-Output "#                       neo42 SPC Cmdlet Demo                      #"
Write-Output "#                            Version 3.0                           #"
Write-Output "#                   Copyright(C) 2020 neo42 GmbH                   #"
Write-Output "#                        Visit www.neo42.de                        #"
Write-Output "####################################################################"
Write-Output ""

#endregion

# Description
# This demo script will show you how to download and deploy the packages from your 
# favorite list. It is required to setup the connection to the Deployment System 
# inside the Service Portal Client GUI
#
# !!!! ATTENTION !!!
#
# This script will automatically download and deploy all found favorite packages (only latest versions)
# Handle with care!
#
# !!!! ATTENTION !!!

#region Demo

# Import the SPC module
Import-Module Neo42.Spc.PsModule

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials -ErrorAction Stop
Write-Output "Your email is $($spcCredentials.UserName)" -ErrorAction Stop

# Connect to the portal and create a session object
$spcSession = $null
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Validate session
if($spcSession -eq $null)
{
	Write-Output "Failed to create Service Portal Session"
	Exit -1
}

# Get the list of packages (latest versions) found in your favorite list
$favPackages = Get-SpcFavorites -Session $spcSession

# Display the list
$favPackages

# Add the packages to your cart
$favPackages | Add-SpcCartItem -Session $spcSession

# Start the download and deploy if possible
Write-Output "Download:"

#Use default pathes from GUI 
#$result = Start-SpcDownload -Session $spcSession -DeployMode Deploy -DirectorySubtree $true

#Use special pathes
$downloadBase = "$env:USERPROFILE\Downloads\_SPC"
$result = Start-SpcDownload -Session $spcSession -DeployMode Extract -Verbose -DownloadDestinationPath "$downloadBase\Download" -ExtractDestinationPath "$downloadBase\Extract" -DirectorySubtree $true

$result | % { $_.ToString() }

Write-Output ""

# Close the connection
Close-SpcConnection

#endregion
