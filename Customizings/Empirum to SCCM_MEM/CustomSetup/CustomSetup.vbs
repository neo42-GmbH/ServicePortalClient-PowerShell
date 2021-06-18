'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'CustomSetupInfo
'Author                  = neo42 GmbH
'CreationDate            = 05.05.2021
'Description             = Customizing for neo42 Packages (migrated to MS Endpoint Mgr)
'Tested on               = Win7 x86, Win7 x64, Win8.1 x86, Win8.1 x64, Win10 x86, Win10 x64
'Dependencies            = >= neolib.n42 5.02
'Last Change             = 05.05.2021
'Build                   = 0
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Option Explicit 

'[Dim]
Dim DeleteEmpirumKeys
Dim EqualText, LesserText, GreaterText

'[Main]
EqualText = "(migrated to MS Endpoint Mgr)"
LesserText = "(updated by MS Endpoint Mgr)"
GreaterText = "(you must update with MS Endpoint Mgr Package)"
DeleteEmpirumKeys = 0

If UserPartMode = False Then
  If UninstallMode = False Then
    'Echo "Custom Install MachinePart"
    ' your code here
    FindEmpirum EqualText, LesserText, GreaterText, DeleteEmpirumKeys
 
  ElseIf UninstallMode = True Then
    'Echo "Custom Uninstall MachinePart"
    ' your code here

  End If
ElseIf UserPartMode = True Then
  If UninstallMode = False Then
    'Echo "Custom Install UserPart"
    ' your code here

  End If
End If

'---------------------------------------------------------------------
Public Function FindEmpirum(EqualText, LesserText, GreaterText, DeleteEmpirumKeys)
  Dim RegKey, Value, ValueData, SubKeyArray, x, i
  Dim RootKeyNormal, RootKeyx86x64, RootKey
  Dim CheckMachineKey, CheckVersion
  Dim SplitPathArray, PackageFamilyPath
  Dim EmpirumUninstallKey, EmpirumMaschineKey

  RootKeyNormal = "HKLM\Software"
  RootKeyx86x64 = "HKLM\Software\Wow6432Node"

  RootKey = RootKeyNormal

  For i = 1 to 2
    RegKey = RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall"

    If RegRead(RootKeyNormal & "\Microsoft\Windows\CurrentVersion\Uninstall\" & UninstallKeyName & "\DisplayVersion") = Version AND RegRead(RootKeyNormal & "\" & MachineKeyName & "\Revision") = Revision Then
      'Echo "Install Success"

      EmpirumUninstallKey = ""
      EmpirumMaschineKey = ""
      Value = "MachineKeyName"
      ValueData = "*"
      SubKeyArray = RegFindSubKeys(RegKey, Value, ValueData)
      For x = 1 to Ubound(SubKeyArray)
        CheckMachineKey = RegRead(RegKey & "\" & SubKeyArray(x) & "\MachineKeyName")
        If RegExists(RootKey & "\" & CheckMachineKey & "\Setup\ProductName") = True Then
          SplitPathArray = Split(CheckMachineKey, "\")
          If Ubound(SplitPathArray) = 2 Then
            If SplitPathArray(0) & "\" & SplitPathArray(1) = DeveloperName & "\" & ProductName Then
              EmpirumUninstallKey = SubKeyArray(x)
              EmpirumMaschineKey = CheckMachineKey
            End If
          ElseIf Ubound(SplitPathArray) = 3 Then
            If SplitPathArray(1) & "\" & SplitPathArray(2) = DeveloperName & "\" & ProductName Then
              EmpirumUninstallKey = SubKeyArray(x)
              EmpirumMaschineKey = CheckMachineKey
            End If 
          End If
        End If
      Next
      'Echo "EmpirumUninstallKey = " & EmpirumUninstallKey
      'Echo "EmpirumMaschineKey = " & EmpirumMaschineKey

      If EmpirumMaschineKey <> "" Then
        CheckVersion = RegRead(RegKey & "\" & EmpirumUninstallKey & "\DisplayVersion")
        If VersionCompare(CheckVersion, Version) = 1 Then
          'Echo CheckVersion & " gleiche Version"
          If DeleteEmpirumKeys = 1 Then
            RegDelete RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\"
            RegDelete RootKey & "\" & EmpirumMaschineKey & "\"
            RegDeleteEmptyPath RootKey & "\" & EmpirumMaschineKey & "\"
          Else
            RegWrite RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\DisplayName", EmpirumUninstallKey & " " & EqualText, "REG_SZ"
            RegWrite RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\SystemComponent", 1, "REG_DWORD"
            RegWrite RootKey & "\" & EmpirumMaschineKey & "\Setup" & "\ProductName", ProductName & " " & EqualText, "REG_SZ"
          End If
        ElseIf VersionCompare(CheckVersion, Version) = 2 Then
          'Echo CheckVersion & " kleiner Version"
          If DeleteEmpirumKeys = 1 Then
            RegDelete RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\"
            RegDelete RootKey & "\" & EmpirumMaschineKey & "\"
            RegDeleteEmptyPath RootKey & "\" & EmpirumMaschineKey & "\"
          Else
            RegWrite RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\DisplayName", EmpirumUninstallKey & " " & LesserText, "REG_SZ"
            RegWrite RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\SystemComponent", 1, "REG_DWORD"
            RegWrite RootKey & "\" & EmpirumMaschineKey & "\Setup" & "\ProductName", ProductName & " " & LesserText, "REG_SZ"
          End If
        ElseIf VersionCompare(CheckVersion, Version) = 3 Then
          'Echo CheckVersion & " groesser Version"
          If DeleteEmpirumKeys = 1 Then
            RegDelete RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\"
            RegDelete RootKey & "\" & EmpirumMaschineKey & "\"
            RegDeleteEmptyPath RootKey & "\" & EmpirumMaschineKey & "\"
          Else
            RegWrite RootKey & "\Microsoft\Windows\CurrentVersion\Uninstall\" & EmpirumUninstallKey & "\DisplayName", EmpirumUninstallKey & " " & GreaterText, "REG_SZ" 
            RegWrite RootKey & "\" & EmpirumMaschineKey & "\Setup" & "\ProductName", ProductName & " " & GreaterText, "REG_SZ"
          End If
        End If

        'MS Endpoint Mgr Uninstallkey
        'RegWrite RootKeyNormal & "\Microsoft\Windows\CurrentVersion\Uninstall\" & UninstallKeyName & "\DisplayName", UninstallDisplayName & " " & "(MS Endpoint Mgr)", "REG_SZ"
        Exit For
      Else
        RootKey = RootKeyx86x64
      End If
    End If
  Next
End Function