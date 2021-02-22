<#
.SYNOPSIS
    Deletes the .url documentation file in the package directory
.DESCRIPTION
    Deletes the .url documentation file in the package directory.    
    The main purpose of this script is to demonstrate the use of the 'Customizing Scripts' feature in the neo42 Service Portal Client.

    Target deployment system: All
    Hook:                     Before deployment
    Required parameters:      Temporary package path, Package name, Version, Revision
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
    .\Delete-DocumentationFile.ps1 -PackagePath {TEMP_PATH} -PackageName {PACKAGE_NAME} -Version {VERSION} -Revision {REVISION}
#>


param 
    (    
        [string]
        # The current path of the package
        $PackagePath,

        [string]
        # The name of the package
        $PackageName,

        [string]
        # The Version of the package
        $Version,

        [string]
        # The Revision of the package
        $Revision
    )

$installDir = Join-Path -Path $PackagePath -ChildPath "neoInstall" -Resolve
$targetFileName = $PackageName.Replace(" ", "_") + "_Ver" + $Version + "_Rev" + $Revision + ".url"
$targetFilePath = Join-Path -Path $installDir -ChildPath $targetFileName 

Remove-Item -Path $targetFilePath
Exit