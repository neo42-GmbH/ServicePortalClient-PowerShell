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
# This demo script will show you how to search for packages in the neo42 Service Portal
# Found packages can downloaded and deployed automatically
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
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Validate session
if($spcSession -eq $null)
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
Search-SpcPackages -Session $spcSession -Product "7-Zip" | ForEach-Object { Add-SpcCartItem -Session $spcSession -SkipList -PackageID $_.PackageID -DeploymentSystem $_.Service }

# Search for latest version of a tool and set as cart item
Search-SpcPackages -Session $spcSession -Product "Service Portal Client" -Service Tool | ForEach-Object { Add-SpcCartItem -Session $spcSession -SkipList -PackageID $_.PackageID -DeploymentSystem $_.Service }

Get-SpcCartItem -Session $spcSession

# Start the download and deploy if possible
Start-SpcDownload -Session $spcSession -DeployMode Deploy -DirectorySubtree $true

# Close the connection
Close-SpcConnection

#endregion
