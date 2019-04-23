```powershell

$ServerParams = @{
    DeploymentGroup = "UKDB-REF-BUILD-BLUE"
    role            = "mirror"
    dns             = $env:EndPoint
}

Install-VSTSAgent -ServerParams $ServerParams -Verbose

```
