#requires -version 5
<#
.SYNOPSIS
    Imports Deployment System Settings
.DESCRIPTION
	This demo script will show you how to download and deploy the packages from your 
	favorite list. It is required to setup the connection to the Deployment System 
	inside the Service Portal Client GUI
	
	!!! ATTENTION !!!
	This script will automatically download and extract all found favorite packages (only latest versions)
 	Handle with care!
	!!! ATTENTION !!!

.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.2
    Author:         neo42 GmbH
    Creation Date:  21.09.2022
    Purpose/Change: Updated Header and improved formatted list output
    Requirements:   neo42 Service Portal Client Version 3.7.x
  
.EXAMPLE
    .\SpcFavorites.ps1
#>
# Import the SPC module
Import-Module Neo42.Spc.PsModule

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials -ErrorAction Stop
Write-Output "Your email is $($spcCredentials.UserName)" -ErrorAction Stop

# Connect to the portal and create a session object
$spcSession = $null
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Validate session
if($null -eq $spcSession)
{
	Write-Output "Failed to create Service Portal Session"
	Exit -1
}

# Get the list of packages (latest versions) found in your favorite list
$favPackages = Get-SpcFavorites -Session $spcSession

# Display the list
$favPackages

# clear existing cart Items
Clear-SpcCartItem -Session $spcSession

# Add the packages to your cart
$favPackages | ForEach-Object { Add-SpcCartItem -Session $spcSession -PackageID $_.PackageID -DeploymentSystem $_.Service -SkipList }
Get-SpcCartItem -Session $spcSession | Select-Object PackageID,ReleaseDate,Developer,Product,Version,Service | Format-Table

# Start the download and deploy if possible
Write-Output "Download:"

#Use default pathes from GUI 
#$result = Start-SpcDownload -Session $spcSession -DeployMode Deploy -DirectorySubtree $true

#Use special pathes
$downloadBase = "$env:USERPROFILE\Downloads\_SPC"
$result = Start-SpcDownload -Session $spcSession -DeployMode Extract -Verbose -DownloadDestinationPath "$downloadBase\Download" -ExtractDestinationPath "$downloadBase\Extract" -DirectorySubtree $true

$result | ForEach-Object { $_.ToString() }

Write-Output ""

# Close the connection
Close-SpcConnection
