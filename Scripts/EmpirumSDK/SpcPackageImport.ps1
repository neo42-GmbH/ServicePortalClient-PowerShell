#requires -version 5
<#
.SYNOPSIS
    Imports Software to the specified deploymentsystem
.DESCRIPTION
	This demo script will show you how import packages with default properties into 
	your deployment system. It is required to setup the connection to the Deployment
	System inside the Service Portal Client GUI.
	
	!!! Attention !!!
	This script will automatically import all found Packages to the Deploymentsystem
	Handle with Care
	!!! Attention !!!

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
$deploymentSystem = "EmpirumSDK"

# Provide the extension of your script files
# .vbs for SCCM, Intune and WSO
# .inf for Empirum
$scriptExtension = ".inf"

# Provide the folder path where the packages are stored
$scriptPath = "$env:USERPROFILE\Downloads\neo42 Services"

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


# $firstScript: Contains the script path to demonstrate if we can remove one script from the package import list
[string]$firstScript = ""

# Get all script files from given folder
Write-Output ""
Write-Output "Search $scriptExtension - Files in $scriptPath ..."

$scriptfiles = Get-ChildItem -Path $scriptPath -Recurse | Where-Object {$_.Extension -eq $scriptExtension}
foreach($script in $scriptfiles)
{
	# Add additional filter to pre-validate the script - add more / other if required
	if($($script.FullName) -like '*install\*' -and $($script.Name) -like 'Setup*')
	{
		Write-Output ""
		Write-Output ".. Try to add $script .."
		# Add the package to the import list
		$result = Add-SpcPackageImport -Session $spcSession -Path  $($script.FullName) -DeploymentSystem $deploymentSystem

		# Validate the result
		if([int]$result -eq -1)
		{
			Write-Output "Add $($script.FullName) to import list failed"
			# Proceed as needed...
		}

		# Save the script path if not set any
		if( $firstScript -eq "" )
		{
			$firstScript = $script.FullName
		}
	}
}

# Display the list 
Write-Output ""
Write-Output "Get Package import list"
Get-SpcPackageImport -Session $spcSession

# Remove the first script from list
if( $firstScript -ne "" )
{
	Write-Output ""
	Write-Output "Try to Remove $firstScript"
	$result = Remove-SpcPackageImport -Session $spcSession -Path  $firstScript -DeploymentSystem $deploymentSystem

	# Validate the result
	if([int]$result -ne 0)
	{
		Write-Output "Failed to remove $($script.FullName)"
		# Proceed as needed...
	}

	# Display the modified list
	Write-Output "$firstScript removed:"
	Get-SpcPackageImport -Session $spcSession
}

# Clear the list if you don't like the result
#Clear-SpcPackageImport -Session $spcSession

# Start the import process for all packages in the list
Write-Output ""
Write-Output "Try to import .."
Start-SpcPackageImport -Session $spcSession | ForEach-Object { $_.ToString() }

#endregion