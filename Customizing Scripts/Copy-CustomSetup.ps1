#requires -version 4
<#
.SYNOPSIS
    Copies directory like CustomSetup directory to package directory/neoinstall
.DESCRIPTION
    Copies directory like CustomSetup directory to package directory/neoinstall
    You can find the CustomSetup features documented in the neo42 Service Portal - "Paketdepot S Dokumente/Anleitungen"
    The main purpose of this script is to demonstrate the use of the 'Customizing Scripts' feature in the neo42 Service Portal Client.
    Target deployment system: SCCM, Intune, WSO
    Hook:                     Before deployment
    Required parameters:      $PackagePath
    Caution: Use at own risk !!!
.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.0
    Author:         neo42 GmbH
    Creation Date:  19.05.2021
    Purpose/Change: Initial commit
    Requirements:   ConfigurationManager/Endpointmanager/WSO
.EXAMPLE
    .\Copy-CustomSetup.ps1 -PackagePath {TEMP_PATH}
#>
param(
    [string]
    # The current path of the package
    $PackagePath
)

$SourceDirectory = "C:\neo42\PackageCustomizing\CustomSetup";

Copy-Item -Path $SourceDirectory -Destination $PackagePath/neoinstall -Recurse -Force
