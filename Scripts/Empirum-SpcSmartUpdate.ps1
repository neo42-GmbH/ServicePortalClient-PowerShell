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
# This demo script will show you how find packages that could be updated with newer
# versions from the Service Portal. It is required to setup the connection to the
# Deployment System inside the Service Portal Client GUI
#
# !!!! ATTENTION !!!
#
# This script will automatically download and deploy all found packages
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

# Get the list of packages found by SmartUpdate
$suPackages = Get-SpcSmartUpdate -Session $spcSession -DeploymentSystem Empirum -ShowDetectedVersion

# Check the result
if($suPackages -eq $null)
{
	Write-Output "No packages found via smart update"
	Exit
}

# Display the list
$suPackages

# Add the packages to your cart
$suPackages | Add-SpcCartItem -Session $spcSession -DeploymentSystem Empirum

# Start the download and deploy if possible
Start-SpcDownload -Session $spcSession -DeployMode Deploy -DirectorySubtree $true

# Close the connection
Close-SpcConnection

#endregion
