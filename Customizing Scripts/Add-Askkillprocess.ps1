#requires -version 4
<#
.SYNOPSIS
    Adds the ./CustomSetup/CustomSettings.cfg file with a customizable AskkillProcess behavior to the neoinstall folder
.DESCRIPTION
    Adds the ./CustomSetup/CustomSettings.cfg file with a customizable AskkillProcess behavior to the neoinstall folder
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
    Creation Date:  15.03.2021
    Purpose/Change: Initial commit
    Requirements:   ConfigurationManager/Endpointmanager/WSO
.EXAMPLE
    .\Add-Askkillprocess.ps1 -PackagePath {TEMP_PATH} -Timeout 10 -ContinueType Continue -ALLOWABORTBYUSER False
#>
param(
    [string]
    # The current path of the package
    $PackagePath,
    [string]
    # Countdown Duration
    $TimeOut="30",
    [string][Validateset("Continue","Abort")]
    # Continue or Abort when the Countdown finishes
    $ContinueType="Abort",
    [string][Validateset("True","False")]
    # Allow the User to abort the Setup
    $ALLOWABORTBYUSER="True"
)
mkdir $PackagePath/neoinstall/CustomSetup
$CustomSettingsCFGContent =
";### ASKKILLPROCESSES #############################################################################
;### More features documented in the neo42 Service Portal - `"Paketdepot S Dokumente/Anleitungen`"
[ASKKILLPROCESSES]
TIMEOUT=$TimeOut
CONTINUETYPE=$ContinueType
ALLOWABORTBYUSER=$ALLOWABORTBYUSER"
$CustomSettingsCFGContent | Out-File -FilePath $PackagePath/neoinstall/CustomSetup/CustomSettings.cfg -Encoding utf8