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
# This demo script will show you the following cenario:
# First we copy the packages from your favorite list to your Cart.
# Then we remove the BlackList items from your Cart.
# Last we download and extract the packages.

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

# Export of the deployment settings for the SCCM System
Export-SpcDeploymentSettings -Session $spcSession -Path "C:\Temp\SCCM-Settings.json" -DeploymentSystem SCCM

# Import of the deployment settings for the SCCM System
Import-SpcDeploymentSettings -Session $spcSession -Path "C:\Temp\SCCM-Settings.json" -DeploymentSystem SCCM