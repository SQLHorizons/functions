```powershell

$express = "\\ms-oc27\data\SQLEXPRADV_SP2_x64_ENU.exe"
$source_dir = "C:\Users\Administrator\Downloads\SQL2016_EXPR_x64_ENU"
$Newiso     = "C:\Users\Administrator\Downloads\SQLServer2016-SP2-x64-ENU-Exp.iso"

& $express /x:$source_dir

Get-ChildItem "$source_dir" | New-ISOFile -path $Newiso -Title "SQL2016_x64_ENU" -Verbose -Force

```
