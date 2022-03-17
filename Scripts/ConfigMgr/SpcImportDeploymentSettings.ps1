#requires -version 5
<#
.SYNOPSIS
    Imports Deployment System Settings
.DESCRIPTION
    This demo script will show you the following cenario:
	Imports the Settings for the specified Deployment System
	
	!!! ATTENTION !!!
	The exported Deployment Settings can contain credentials
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
    .\SpcDeploymentSettings.ps1
#>
# Import the SPC module
Import-Module Neo42.Spc.PsModule
$deploymentSystem = "SCCM"

$OutputDirectory = "C:\Temp"

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
# Create Temp Folder if it does not exist
New-Item -ItemType Directory $OutputDirectory -ea 0

# Import of the deployment settings for the Deployment System
Import-SpcDeploymentSettings -Session $spcSession -Path "$OutputDirectory\$deploymentSystem-Deployment-Settings.json" -DeploymentSystem $deploymentSystem