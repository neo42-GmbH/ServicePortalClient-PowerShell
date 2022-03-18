#requires -version 5
<#
.SYNOPSIS
    Performs the CleanupAction on a list of all software packages matching the chosen retirement criteria
.DESCRIPTION
    Get a full list of the of packages matching the chosen retirement criteria (cleanupaction)
	Performs the appropriate CleanupAction on the list of Packages found.  
    It is required to setup the connection to the Empirum deploymentsystem and configure the cleanup settings.
    
    !!! ATTENTION !!!
	This script will move or even delete the affected packages from the deploymentsystem 
	Handle with care!
	!!! ATTENTION !!!

.INPUTS
    none
.OUTPUTS
    none
.NOTES
    Version:        1.0
    Author:         neo42 GmbH
    Creation Date:  18.03.2022
    Purpose/Change: Initial Version
    Requirements:   neo42 Service Portal Client Version 3.6.x
  
.EXAMPLE
    .\SpcCleanupPackagesStage1.ps1
#>
# Import the SPC module
Import-Module Neo42.Spc.PsModule
# Choose the Deploymentsystem
$DeploymentSystem = "Empirum"

# Define the criteria referred to as cleanupaction 
# Choose between NoAssignmentInstallApproved, NoAssignmentNoInstallApproved, AllPackages
$CleanupAction = "NoAssignmentNoInstallApproved"

# Define an additional filter on Developer and SoftwareName
$DeveloperFilter = "*Microsoft*"
$SoftwareFilter = "*edge*"

# Read credentials from windows credential manager
$spcCredentials = Get-SpcCredentials -ErrorAction Stop
Write-Output "Your email is $($spcCredentials.UserName)" -ErrorAction Stop

# Connect to the portal and create a session object
$spcSession = Open-SpcConnection -Credentials $spcCredentials

# Validate session
if($null -eq $spcSession)
{
	Write-Output "Failed to create Service Portal Session"
	Exit -1
}

# Find-SpcCleanupPackages will return a list of packages that matches the SelectedCleanupAction, in this example filtered by developer and Softwarename
$packages = Find-SpcCleanupPackages -Session $SpcSession -DeploymentSystem $DeploymentSystem -SelectedCleanupAction $CleanupAction | Where-Object {$_.SoftwareDev -like $DeveloperFilter -and $_.SoftwareName -like $SoftwareFilter}

# Add all objects from packges to the cleanup list
$packages | ForEach-Object { Add-SpcCleanupPackages -Session $SpcSession -DeploymentSystem $DeploymentSystem -Package $_ }

# You can show your complete cleanup list if needed
Get-SpcCleanupPackages -Session $SpcSession -DeploymentSystem $DeploymentSystem

# If you want to remove a single package
# $removePackage = $packages | Select-Object -first 1
# Remove-SpcCleanupPackages -Session $SpcSession -DeploymentSystem $DeploymentSystem -Package $removePackage

# If you want to remove all packages from your cleanup list
# Clear-SpcCleanupPackages -Session $SpcSession -DeploymentSystem $DeploymentSystem

# When your cleanup list is correctly filled start with the cleanup
# ClearDuplictes should be on true to clear all duplicates if found
# Move or delete the cleanup list depending on the choosen action
Start-SpcCleanupPackages -Session $spcSession -DeploymentSystem $DeploymentSystem -SelectedCleanupAction $CleanupAction -ClearDuplicates $true

# Close the connection
Close-SpcConnection

