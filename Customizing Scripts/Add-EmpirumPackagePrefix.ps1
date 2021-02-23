#requires -version 4
<#
.SYNOPSIS
    Adds a prefix to the name of an existing package in the Empirum database
.DESCRIPTION
    Searches an existing Empirum package by the 'PackageName' and adds the given prefix to the name.
    The main purpose of this script is to demonstrate the use of the 'Customizing Scripts' feature in the neo42 Service Portal Client.

    Target deployment system: Empirum
    Hook:                     After deployment
    Required parameters:      Database package name

    Caution: Use at own risk !!!
    Direct changes in the Empirum database can have unforeseen effects and may not work in further versions!
.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.0
    Author:         neo42 GmbH
    Creation Date:  22.02.2021
    Purpose/Change: Initial commit
    Requirements:   SQLSysClrTypes, SharedManagementObjects, PowerShellTools - available from: https://www.microsoft.com/de-de/download/details.aspx?id=54279
                    The executing user must have the appropriate rights in the database
.EXAMPLE
    .\Add-EmpirumPackagePrefix.ps1 -ConnectionString {SQL_CONNECTION_STRING} -PackageName {DB_PACKAGE_NAME} -TargetPrefix "Test - "
#>

param
    (
        [string]
        # Specifies the sql server and the target database
        $ConnectionString,

        [string]
        # Specifies the name of the package that should be modified.
        $PackageName,

        [string]
        # Specifies the prefix added to the current name
        $TargetPrefix
    )


$targetSwQuery = "SELECT [SoftwareID],[SoftwareName] FROM [Software] where Type = 'App' AND PackageName = '{TARGETPACKAGENAME}'"
$updatePackageStatement = "UPDATE [Software] SET [SoftwareName] = '{SOFTWARENAME}' WHERE [SoftwareId] = '{SOFTWAREID}'"

Invoke-Sqlcmd -Query "Select * FROM clients" -ConnectionString "$ConnectionString"

$dbPackage = Invoke-Sqlcmd -Query $targetSwQuery.Replace("{TARGETPACKAGENAME}", $PackageName) -ConnectionString "$ConnectionString"
if($dbPackage -eq $null)
{
    Write-Warning "Package not found or no connection to Empirum database."
    Write-Warning "Package: '$PackageName'"
    Write-Warning "Database: '$ConnectionString'"
    Start-Sleep -Seconds 5
    Exit -1
}

$result = Invoke-Sqlcmd -Query $updatePackageStatement.Replace("{SOFTWARENAME}", $targetPrefix + $dbPackage.SoftwareName).Replace("{SOFTWAREID}", $dbPackage.SoftwareId) -ConnectionString "$ConnectionString"
Exit

