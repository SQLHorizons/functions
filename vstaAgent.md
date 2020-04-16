# Clients

## Osprey

```powershell

$ServerParams = @{
    DeploymentGroup = "UKDB-HOME"
    role            = "osprey"
    dns             = "osprey.sqlhorizons.com"
}

##  import functions.
$url = "https://raw.githubusercontent.com/SQLHorizons/functions/master/public"
[Environment]::SetEnvironmentVariable("functions", $url, "Process")

Invoke-WebRequest -UseBasicParsing "$env:functions/Install-VSTSAgent.ps1" | Invoke-Expression
Install-VSTSAgent -ServerParams $ServerParams -Verbose

```

## Henry

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

## Falcon

```powershell

$ServerParams = @{
    DeploymentGroup = "UKDB-HOME"
    role            = "development"
    dns             = "falcon.sqlhorizons.com"
}

##  import functions.
$url = "https://raw.githubusercontent.com/SQLHorizons/functions/master/public"
[Environment]::SetEnvironmentVariable("functions", $url, "Process")

Invoke-WebRequest -UseBasicParsing "$env:functions/Install-VSTSAgent.ps1" | Invoke-Expression
Install-VSTSAgent -ServerParams $ServerParams -Verbose

```
