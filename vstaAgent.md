```powershell

$ServerParams = @{
    DeploymentGroup = "UKDB-HOME"
    role            = "henry"
    dns             = "WIN10HENY12-DC5"
}

##  import functions.
$url = "https://raw.githubusercontent.com/SQLHorizons/functions/master/public"
[Environment]::SetEnvironmentVariable("functions", $url, "Process")

Invoke-WebRequest -UseBasicParsing "$env:functions/Install-VSTSAgent.ps1" | Invoke-Expression
Install-VSTSAgent -ServerParams $ServerParams -Verbose

```
