#region Header

$Host.UI.RawUI.BackgroundColor = 'White'
$Host.UI.RawUI.ForegroundColor = 'Black' 
Clear-Host

Write-Output "####################################################################"
Write-Output "#                       neo42 SPC Cmdlet Demo                      #"
Write-Output "#                            Version 3.3                           #"
Write-Output "#                   Copyright(C) 2020 neo42 GmbH                   #"
Write-Output "#                        Visit www.neo42.de                        #"
Write-Output "####################################################################"
Write-Output ""

#endregion

# Description
# This demo script will show you how to configure the script signing feature and how to use it.

#region Demo

# Import the SPC module
Import-Module Neo42.Spc.PsModule

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials -ErrorAction Stop
Write-Output "Your email is $($spcCredentials.UserName)" -ErrorAction Stop

# Connect to the portal and create a session object
$spcSession = $null
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Configure the script signing feature
Set-SpcScriptSigningSettings -Session $spcSession -CertificatePath "C:\Temp\certificate.pfx" -CertificatePassword "password"

# Get the script signing settings to check if the settings are already set
# Get-SpcScriptSigningSettings -Session $spcSession

# Start the signing of a .vbs script file
Start-SpcScriptSigning -Session $spcSession -ScriptFilePath "C:\Temp\Script.vbs"

#endregion