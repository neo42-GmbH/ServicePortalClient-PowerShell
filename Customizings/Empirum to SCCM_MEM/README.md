# Empirum to SCCM/MEM Migration - CustomSetup Script for neo42 SCCM Packages
VBS Script that allow you to migrate Empirum Package Registry Keys while installing an SCCM Package

To apply this customizing, proceed as follows:
Copy the CustomSetup directory into the neoInstall directory of the SCCM package.
so that it looks like this 'neoInstall\CustomSetup'.
As soon as a neo42 SCCM package finds the CustomSetup.vbs file in the CustomSetup directory,
it is automatically executed after the Setup.vbs file.  
The prerequisite for running CustomSetup.vbs is a neolib.n42 >= 5.02 in the neoInstall directory.
We recommend using neolib.n42 >= 6.03, which can be found in the development document collection 'Development_xxx.zip' in the neo42 packagedepot portal.

This CustomSetup.vbs does the following:
* Empirum package is installed and an newer Version of SCCM package is being installed.  
  This migration method is the preferred one.  
  1. neolib.n42 < 6.03  
     Empirum package is marked hidden and is renamed in registry to  
     '[old ProductName] (updated by MS Endpoint Mgr)'.
  2. neolib.n42 >= 6.03 and Flag UninstallOld=1 in Setup.vbs  
     Empirum package will be uninstalled.  
     If you do not want an older Empirum package to be uninstalled by a newer SCCM package, set the EmpirumPackageCheck=0 flag in Setup.vbs.  
     In this case Empirum package is marked hidden and is renamed in registry to  
     '[old ProductName] (updated by MS Endpoint Mgr)'.
* Empirum package is installed and the same Version of SCCM package will be installed.  
  The soft migration from SCCM package recognizes the Empirum package (AppExist),  
  the Empirum package is marked hidden and renamed in registry to  
  '[old ProductName] (migrated to MS Endpoint Mgr)'.  
  Installation of SCCM package is not executed. Only Setup.vbs is copied and package is registered.  
  
* Empirum package is installed and an older Version of SCCM package will be installed.  
  If possible, this installation should never be carried out, as it usually leads to errors.  
  Whether or not the SCCM package is installed depends on a number of factors.  
  Empirum package is renamed in registry to  
  '[old ProductName] (you must update with MS Endpoint Mgr Package)'.  
  
* If you want the Empirum Package Registry Keys to be deleted instead of changed,  
  change DeleteEmpirumKeys=0 to DeleteEmpirumKeys=1 in CustomSetup.vbs.  

     
  
  
  
     
     
    
    


