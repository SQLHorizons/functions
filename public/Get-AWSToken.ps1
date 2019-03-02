function Get-AWSToken {

    [CmdletBinding()]
    [OutputType([Amazon.Runtime.AWSCredentials])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $SecretKey  = [SecureString]($env:AWS_SECRETKEY|ConvertTo-SecureString -AsPlainText -Force),

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential = [PSCredential]::New($env:AWS_ACCESSKEY, $SecretKey),

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $RoleSessionName = "deployer",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $RoleArn = $env:AWS_ROLEARN,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Region = "eu-west-2"
    )

    Try {

        $STSrole = @{
            RoleSessionName = $RoleSessionName
            AccessKey = $Credential.UserName
            SecretKey = $Credential.GetNetworkCredential().Password
            RoleArn   = $RoleArn
            Region    = $Region
        }

        ##  ALL DONE
        Return (Use-STSRole @STSrole).Credentials

    }
    Catch [System.Exception] {

        Write-Information "Error at line: $($PSItem[0].InvocationInfo.line)"
        $PSCmdlet.ThrowTerminatingError($PSItem)

    }

}
