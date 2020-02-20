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
# First we get the black list and display it
# Then we get the last item from the list and remove it from the black list.
# Now it will add to the list.
# If nothing in the list, we searching for a product in the package list and add/remove it from the black list.

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

# Get Black-List
$blackList = Get-SpcSmartUpdateBlackList -Session $spcSession -DiscardImpossibles
Write-Output "BlackList:"
$blackList
$blackItem = $blackList | Select-Object -Last 1

if( $blackItem -ne $null )
{
	
	Write-Output ""
	Write-Output "BlackList without last item:"
	Remove-SpcSmartUpdateBlackList -PackageID $blackItem.PackageID -Session $spcSession

	Write-Output ""
	Write-Output "BlackList with last item:"
	Add-SpcSmartUpdateBlackList -PackageID $blackItem.PackageID -Session $spcSession
}
else
{
	$developer = "3Dis"
	Write-Output "No variable items in the BlackList, Add and remove products from the developer '$developer'"
	Get-SpcSmartUpdateBlackList -Session $spcSession

	Write-Output ""
	Write-Output "BlackList with '$developer':"
	$tmpList = Search-SpcPackages -Session $spcSession -Developer $developer
	$tmpList | Add-SpcSmartUpdateBlackList -Session $spcSession

	Write-Output ""
	Write-Output "BlackList without '$developer':"
	$tmpList | Remove-SpcSmartUpdateBlackList -Session $spcSession
}

# Close the connection
Write-Output ""
Write-Output "Close Connection"
Close-SpcConnection

#endregion