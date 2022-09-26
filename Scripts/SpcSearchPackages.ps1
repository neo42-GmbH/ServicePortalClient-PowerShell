#requires -version 5
<#
.SYNOPSIS
    Imports Deployment System Settings
.DESCRIPTION
    This demo script will show you how to search for packages in the neo42 Service Portal
 	Found packages can be downloaded and deployed automatically
	
	!!! ATTENTION !!!
	This script will automatically download and deploy all found favorite packages (only latest versions)
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
    Purpose/Change: Updated header and Deploymentsystem parameter for Tools
    Requirements:   neo42 Service Portal Client Version 3.7.x
  
.EXAMPLE
    .\SpcSearchPackages.ps1
#>
# Import the SPC module
Import-Module Neo42.Spc.PsModule
$deploymentSystem = "<deploymentsystem>"

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials -ErrorAction Stop
Write-Output "Your email is $($spcCredentials.UserName)" -ErrorAction Stop

# Connect to the portal and create a session object
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Validate session
if($null -eq $spcSession)
{
	Write-Output "Failed to create Service Portal Session"
	Exit -1
}

# Search for packages by Developer
#Search-SpcPackages -Session $spcSession -Developer Adobe

# Search for packages by Product
#Search-SpcPackages -Session $spcSession -Product AIR

# Search for packages and return all versions
#Search-SpcPackages -Session $spcSession -Product AIR -AllVersions

# Search for packages using wildcard
#Search-SpcPackages -Session $spcSession -Product *office*

Clear-SpcCartItem -Session $spcSession

# Search for latest version of a package and set as cart item
Search-SpcPackages -Session $spcSession -Product "7-Zip" -Service $deploymentSystem | ForEach-Object { Add-SpcCartItem -Session $spcSession -SkipList -PackageID $_.PackageID -DeploymentSystem $_.Service }

# Search for latest version of a tool and set as cart item
$SearchProduct = "neo42 Service Portal Client"
Search-SpcPackages -Session $spcSession -Product $SearchProduct -Service Tool | Where-Object {
	$_.Product -like "*$SearchProduct*"
} | ForEach-Object { 
	Add-SpcCartItem -Session $spcSession -SkipList -PackageID $_.PackageID -DeploymentSystem Download
}

Get-SpcCartItem -Session $spcSession

# Start the download and deploy if possible
Start-SpcDownload -Session $spcSession -DeployMode Deploy -DirectorySubtree $true

# Close the connection
Close-SpcConnection
