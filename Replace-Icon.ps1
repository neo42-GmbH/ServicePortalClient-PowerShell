<#
.SYNOPSIS
    Replaces the .ico file in the package directory with another .ico file
.DESCRIPTION
    Replaces the .ico file in the package directory with another .ico file.
    The main purpose of this script is to demonstrate the use of the 'Customizing Scripts' feature in the neo42 Service Portal Client.

    Target deployment system: All
    Hook:                     Before deployment
    Required parameters:      Temporary Setup.ico path
.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.0
    Author:         neo42 GmbH
    Creation Date:  22.02.2021
    Purpose/Change: Initial commit    
.EXAMPLE
    .\Replace-Icon.ps1 -IconPath {TEMP_SETUP_ICO_PATH}
#>

param 
    (    
    [string]
    $IconPath
    )

$replaceIconPath = "C:\Temp\icon.ico";

Copy-Item -Path $replaceIconPath -Destination $IconPath
Exit