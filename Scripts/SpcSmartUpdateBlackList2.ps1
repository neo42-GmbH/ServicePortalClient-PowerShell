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

# Get the list of packages (latest versions) found in your favorite list
$favPackages = Get-SpcFavorites -Session $spcSession

# Display the list
Write-Output ""
Write-Output "Favorites:"
$favPackages

# Add the packages to your cart
$favPackages | Add-SpcCartItem -Session $spcSession
Write-Output ""
Write-Output "Cart content:"
Get-SpcCartItem  -Session $spcSession

# Get Black-List
$blackList = Get-SpcSmartUpdateBlackList -Session $spcSession
Write-Output "BlackList:"
$blackList

# Remove the packages from the Black-List
$blackList | Remove-SpcCartItem -Session $spcSession
Write-Output ""
Write-Output "Current Cart content witout Black-List:"
Get-SpcCartItem  -Session $spcSession

# Start the download and deploy if possible
Write-Output ""
Write-Output "Download:"
#Use default pathes from GUI 
#$result = Start-SpcDownload -Session $spcSession -DeployMode Deploy -DirectorySubtree $true

#Use special pathes
$downloadBase = "$env:USERPROFILE\Downloads\_SPC"
$result = Start-SpcDownload -Session $spcSession -DeployMode Extract -Verbose -DownloadDestinationPath "$downloadBase\Download" -ExtractDestinationPath "$downloadBase\Extract" -DirectorySubtree $true

$result | % { $_.ToString() }

# Close the connection
Write-Output ""
Write-Output "Close Connection"
Close-SpcConnection

#endregion
