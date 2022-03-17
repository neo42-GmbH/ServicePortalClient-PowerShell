#requires -version 5
<#
.SYNOPSIS
    Create a Windows 10 Inplace Upgrade package for Empirum
.DESCRIPTION
    This demo script will show you how to create a Windows 10 Inplace Upgrade package.

.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.1
    Author:         neo42 GmbH
    Creation Date:  17.03.2022
    Purpose/Change: Updated Header, renamed to Empirum Specific
  
.EXAMPLE
    .\SpcEmpirumInplaceUpgradeWizard.ps1
#>
# Import the SPC module
Import-Module Neo42.Spc.PsModule

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials -ErrorAction Stop
Write-Output "Your email is $($spcCredentials.UserName)" -ErrorAction Stop

# Connect to the portal and create a session object
$spcSession = $null
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Create the Windows 10 Inplace Upgrade package
New-SpcInplaceUpgradePackage -Session $spcSession -WindowsSourceFilesPath "C:\Temp\Win10_21H2_German_x64" -PackageTargetPath "C:\Temp\Win10_Package"

#endregion