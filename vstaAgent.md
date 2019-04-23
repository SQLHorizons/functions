```powershell

$ServerParams = @{
    DeploymentGroup = "UKDB-REF-BUILD-BLUE"
    role            = "mirror"
    dns             = "db-oc22.avivahome.com"
}

Install-VSTSAgent -ServerParams $ServerParams -Verbose

```
