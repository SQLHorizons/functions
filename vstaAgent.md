```powershell

$ServerParams = @{
    DeploymentGroup = "UKDB-REF-BUILD-BLUE"
    role            = "mirror"
    dns             = $env:EndPoint
}

##  import functions.
$url = "https://raw.githubusercontent.com/SQLHorizons/functions/master/public"
[Environment]::SetEnvironmentVariable("functions", $url, "Process")

Invoke-WebRequest -UseBasicParsing "$env:functions/Install-VSTSAgent.ps1" | Invoke-Expression
Install-VSTSAgentPool -ServerParams $ServerParams -Verbose

```
