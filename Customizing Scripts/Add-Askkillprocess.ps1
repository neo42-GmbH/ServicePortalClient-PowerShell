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
    Creation Date:  30.03.2022
    Purpose/Change: Initial commit
    Requirements:   ConfigurationManager/Endpointmanager/WSO
.EXAMPLE
    .\Add-Askkillprocess.ps1 -PackagePath {TEMP_PATH} -Timeout 10 -ContinueType Continue -AllowAbortByUser False
#>
param(
    [string]
    # The current path of the package
    $PackagePath,
    [string]
    # Countdown duration in minutes
    $TimeOut="30",
    [string][Validateset("Continue","Abort")]
    # Continue or abort when the countdown finishes
    $ContinueType="Abort",
    [string][Validateset("True","False")]
    # Allow the user to abort the setup
    $AllowAbortByUser="True",
    [string][Validateset(0,1)]
    # Allow the user to close all applications with a button
    $UserCanCloseAll=1,
    [string][Validateset(0,1)]
    # PopupInterval in seconds
    $PopupInterval="300"
)
mkdir $PackagePath/neoinstall/CustomSetup
Copy-Item $PSScriptRoot/Logo/ci_400x75.bmp $PackagePath/neoinstall/CustomSetup/ci.bmp -ea 0
$CustomSettingsCFGContent =
";### ASKKILLPROCESSES #############################################################################
;### More features documented in the neo42 Service Portal - `"Paketdepot S Dokumente/Anleitungen`"
[ASKKILLPROCESSES]
TIMEOUT=$TimeOut
CONTINUETYPE=$ContinueType
ALLOWABORTBYUSER=$AllowAbortByUser
POPUPINTERVAL=$PopupInterval
USERCANCLOSEALL=$UserCanCloseAll

[ASKKILLPROCESSES_DEU]
TOPTEXT_INSTALL=Auf Ihrem Computer soll oben genannte Software installiert oder aktualisiert werden. Dazu beenden Sie bitte die folgende(n) Anwendung(en). Daraufhin geht es automatisch weiter.
BOTTOMTEXT_INSTALL_ABORT=Wenn Sie auf `"Abbrechen`" klicken, wird die Installation gestoppt und spaeter erneut gestartet.
TOPTEXT_UNINSTALL=Auf Ihrem Computer soll oben genannte Software deinstalliert werden. Dazu beenden Sie bitte die folgende(n) Anwendung(en). Daraufhin geht es automatisch weiter.
BOTTOMTEXT_UNINSTALL_ABORT=Wenn Sie auf `"Abbrechen`" klicken, wird die Deinstallation gestoppt und spaeter erneut gestartet.

[ASKKILLPROCESSES_ENU]
TOPTEXT_INSTALL=The above software is to be installed or updated on your computer. To do this, please quit the following application(s). After that it will continue automatically.
BOTTOMTEXT_INSTALL_ABORT=If you click `"Cancel`", the installation will be stopped and restarted later.
TOPTEXT_UNINSTALL=The above software is to be uninstalled on your computer. To do this, please quit the following application(s). After that it will continue automatically.
BOTTOMTEXT_UNINSTALL_ABORT=If you click `"Cancel`", the uninstallation will be stopped and restarted later.
"
$CustomSettingsCFGContent | Out-File -FilePath $PackagePath/neoinstall/CustomSetup/CustomSettings.cfg -Encoding utf8