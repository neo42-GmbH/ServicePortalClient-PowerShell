#requires -version 4
<#
.SYNOPSIS
    Adds a prefix to the name of an existing package in Microsoft Endpoint Manager.
.DESCRIPTION
    Searches an existing Empirum package by the 'Modelname' and adds the given prefix to the name.
    The main purpose of this script is to demonstrate the use of the 'Customizing Scripts' feature in the neo42 Service Portal Client.

    Target deployment system: SCCM
    Hook:                     After deployment
    Required parameters:      $Modelname

    Caution: Use at own risk !!!
.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.0
    Author:         neo42 GmbH
    Creation Date:  22.02.2021
    Purpose/Change: Initial commit
    Requirements:   ConfigurationManager
                    The executing user must have the appropriate rights in Microsoft Enpointmanager
.EXAMPLE
    .\Add-EndpointManagerApplicationPrefix.ps1 -ModelName {APPLICATION_SCOPE_ID}/{APPLICATION_ID}  -AppName {APPLICATION_TITLE} -TargetPrefix "Test - " -SiteCode "CHQ" -ConfigmanagerPath "C:\Program Files (x86)\Microsoft Configuration Manager\\"
#>
param(
    [String]
    # Specifies the ModelName of the Targetted App in Microsoft EndpointManger
    $ModelName,
    [String]
    # Specifies the Appname to be combined with the Chosen Prefix
    $AppName,
    [string]
    # Specifies the prefix added to the current name
    $TargetPrefix,
    [string]
    # Specifies the Enpointmanager Site Code
    $SiteCode,
    [string]
    # Specifies the Enpointmanager Site Code
    $ConfigmanagerPath = "C:\Program Files (x86)\Microsoft Configuration Manager\"
  
)
##Connect to Microsoft EndpointManager Configuration Manager PowerShell CMDLets
Import-Module $ConfigmanagerPath'AdminConsole\bin\ConfigurationManager.psd1'
Set-Location $SiteCode":"

Set-CMApplication -ModelName $ModelName -NewName "ToTest_$AppName"
if ($?) {
    Write-Output "$Appname Rename to $TargetPrefix$AppName"
    Start-Sleep 5
    exit 0
}
else {
    Write-Output "$Appname Rename to $TargetPrefix$AppName failed"
    Start-Sleep 5
    exit -1
}