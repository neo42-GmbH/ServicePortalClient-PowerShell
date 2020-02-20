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
#
# !!!! ATTENTION !!!
#
# This script will automatically deploy all found packages
# Handle with care!
#
# !!!! ATTENTION !!!

#endregion

# Description
# This demo script will show you how import packages with default properties into 
# your deployment system. It is required to setup the connection to the Deployment
# System inside the Service Portal Client GUI.
#

#region Demo

# Import the SPC module
Import-Module Neo42.Spc.PsModule

# Provide the folder path where the packages are stored
$scriptPath = "$env:USERPROFILE\Downloads\neo42 Services"

# Provide the extension of your script files
# .vbs for SCCM 
# .inf for Empirum
$scriptExtension = ".inf"

# $firstScript: Contains the script path to demonstrate if we can remove one script from the package import list
[string]$firstScript = ""

# Get all script files from given folder
Write-Output ""
Write-Output "Search $scriptExtension - Files in $scriptPath ..."

$scriptfiles = Get-ChildItem -Path $scriptPath -Recurse | where {$_.Extension -eq $scriptExtension}
foreach($script in $scriptfiles)
{
	# Add additional filter to pre-validate the script - add more / other if required
	if($($script.FullName) -like '*install\*' -and $($script.Name) -like 'Setup*')
	{
		Write-Output ""
		Write-Output ".. Try to add $script .."
		# Add the package to the import list
		$result = Add-SpcPackageImport -Path  $($script.FullName)

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
Get-SpcPackageImport

# Remove the first script from list
if( $firstScript -ne "" )
{
	Write-Output ""
	Write-Output "Try to Remove $firstScript"
	$result = Remove-SpcPackageImport -Path  $firstScript

	# Validate the result
	if([int]$result -ne 0)
	{
		Write-Output "Failed to remove $($script.FullName)"
		# Proceed as needed...
	}

	# Display the modified list
	Write-Output "$firstScript removed:"
	Get-SpcPackageImport
}

# Clear the list if you don't like the result
#Clear-SpcPackageImport

# Start the import process for all packages in the list
Write-Output ""
Write-Output "Try to import .."
Start-SpcPackageImport | % { $_.ToString() }

#endregion