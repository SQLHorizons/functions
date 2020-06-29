```powershell

$express = "\\ms-oc27\data\SQLEXPRADV_SP2_x64_ENU.exe"
$source_dir = "C:\Users\Administrator\Downloads\SQL2016_EXPR_x64_ENU"
$Newiso     = "C:\Users\Administrator\Downloads\SQLServer2016-SP2-x64-ENU-Exp.iso"

& $express /x:$source_dir

Get-ChildItem "$source_dir" | New-ISOFile -path $Newiso -Title "SQL2016_x64_ENU" -Verbose -Force

```

## Creates a boot-able .iso file

This command creates a boot-able .iso file containing the content from c:\WinPE folder, but the folder itself isn't included. Boot file  etfsboot.com can be found in Windows ADK.

Refer to IMAPI_MEDIA_PHYSICAL_TYPE enumeration for possible media types: http://msdn.microsoft.com/en-us/library/windows/desktop/aa366217(v=vs.85).aspx

```powershell
$Media = "DVDPLUSRW_DUALLAYER"
$NewIsoFileParams = @{
    Path     = "C:\.images\iso\AUTOWIN2019DVD.iso"
    BootFile = "C:\.images\iso\AUTOWIN2019DVD\efi\microsoft\boot\efisys.bin"
    Media    = $Media
    Title    = "SSS_X64FREE_EN-US_DV9"
    Force    = $true
    Verbose  = $true
}
Get-ChildItem "C:\.images\iso\AUTOWIN2019DVD" | New-IsoFile @NewIsoFileParams
```

## Media Types:

- "CDR"
- "CDRW"
- "DVDRAM"
- "DVDPLUSR"
- "DVDPLUSRW"
- "DVDPLUSR_DUALLAYER"
- "DVDDASHR"
- "DVDDASHRW"
- "DVDDASHR_DUALLAYER"
- "DISK"
- "DVDPLUSRW_DUALLAYER"
- "BDR"
- "BDRE"

- Default: "DVDPLUSRW_DUALLAYER"
