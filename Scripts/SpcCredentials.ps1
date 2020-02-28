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
# This demo script will show you how to set, read and remove your credentials for the Service Portal Client
# Saved credentials can be used to run scripts without plaintext credentials inside scripts

#region Functions

function Convert-SpcString($string)
{
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($string)
    return  [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}

#endregion

#region Demo

# Import the SPC module
Import-Module Neo42.Spc.PsModule

# Prompt user for credentials
$credentials = Get-Credential -Message "Please insert your neo42 Service Portal credentials"

# Set credentials - only required once per system until you change your password
$result = Set-SpcCredentials -User $credentials.UserName -Password (Convert-SpcString $credentials.Password)

# Validate result
if([int]$result -eq -1)
{
	Write-Output "Failed to set credentials"
	Exit -1
}

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials

# Validate result
if($spcCredentials -eq $null)
{
	Write-Output "Failed to fetch credentials"
	Exit -1
}

Write-Output "Your email is $($spcCredentials.UserName)"

# Remove credentials without prompt
#$result = Remove-SpcCredentials -Force

# Validate result
#if([int]$result -eq -1)
#{
#	Write-Output "Failed to remove credentials"
#	Exit -1
#}

#endregion
