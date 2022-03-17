#requires -version 5
<#
.SYNOPSIS
    Imports all updatable software
.DESCRIPTION
    This demo script will show you how to find packages that can be updated with newer
	versions from the Service Portal. It is required to setup the connection to the
	Deployment System inside the Service Portal Client GUI
	
	!!! ATTENTION !!!
	This script will also automatically download and deploy all found packages
	Handle with care!
	!!! ATTENTION !!!

.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.1
    Author:         neo42 GmbH
    Creation Date:  17.03.2022
    Purpose/Change: Updated header and Deploymentsystem variable
    Requirements:   neo42 Service Portal Client Version 3.6.x
  
.EXAMPLE
    .\SpcSmartUpdate.ps1
#>
# Import the SPC module
Import-Module Neo42.Spc.PsModule
$deploymentSystem = "WSO"

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

# Get the list of packages found by SmartUpdate
$suPackages = Get-SpcSmartUpdate -Session $spcSession -DeploymentSystem $DeploymentSystem -ShowDetectedVersion

# Check the result
if($null -eq $suPackages)
{
	Write-Output "No packages found via smart update"
	Exit
}

# Display the list
$suPackages

# Remove all packages from your cart
Clear-SpcCartItem -Session $spcSession

# Add the packages to your cart
$suPackages | Add-SpcCartItem -Session $spcSession -DeploymentSystem $DeploymentSystem

# Start the download and deploy if possible
Start-SpcDownload -Session $spcSession -DeployMode Deploy -DirectorySubtree $true -DeploymentSystem $deploymentSystem

# Close the connection
Close-SpcConnection

#endregion
