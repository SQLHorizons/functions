```powershell

$express = "\\ms-oc27\data\SQLEXPRADV_SP2_x64_ENU.exe"
$source_dir = "C:\Users\Administrator\Downloads\SQL2016_EXPR_x64_ENU"
$Newiso     = "C:\Users\Administrator\Downloads\SQLServer2016-SP2-x64-ENU-Exp.iso"

& $express /x:$source_dir

Get-ChildItem "$source_dir" | New-ISOFile -path $Newiso -Title "SQL2016_x64_ENU" -Verbose -Force

```


```powershell

$source_dir = "C:\.images\iso\AUTOWIN2019DVD"
$Newiso     = "C:\.images\iso\AUTOWIN2019DVD.iso"

Get-ChildItem "$source_dir" -Recurse | New-ISOFile -path $Newiso -Title "SSS_X64FREE_EN-US_DV9" -Verbose -Force

```
