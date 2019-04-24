function Install-VSTSAgent {

    [CmdletBinding()]
    [OutputType([System.Int16])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $ServerParams,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $vstsParams = @{
            agent       = "http://ms-oc27:8081/repository/resources/vsts-agents/vsts-agent-win-x64-2.151.0.zip"
            path        = "C:/ProgramData/.resources"
            vsts        = "C:/ProgramData/vsts"
            vstsProject = "UKDB"
            vstsAccount = "sqlhorizons"
            workspace   = "DB_Build"
            token       = $env:VSTS_TOKEN
            Repository  = ".build"
            version     = "1.0.6.3"
        }
    )

    ##  vulnerability Fix for CVE-2017-8563: set security protocol type to TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12

    Try {

        ##  initialise status of the function.
        $status = 0

        ##  starting script.
        $start = Get-Date
        Write-Information "VERBOSE: Executing Script: $($MyInvocation.MyCommand.Name)."

        ##  project environment variables (tags).
        [Environment]::SetEnvironmentVariable("DeploymentGroup", $($ServerParams.DeploymentGroup), "Machine")
        [Environment]::SetEnvironmentVariable("ServerHaDrRole", $($ServerParams.role), "Machine")
        [Environment]::SetEnvironmentVariable("EndPoint", $($ServerParams.dns), "Machine")
        
        ##  install deploy module.
        Remove-Module deploy -Force -ErrorAction Ignore
        Get-InstalledModule deploy -RequiredVersion $($vstsParams.version) -ErrorAction Ignore | Uninstall-Module -Force -ErrorAction Ignore
        Find-Module deploy -Repository $($vstsParams.Repository) -MinimumVersion $($vstsParams.version) | Install-Module -AllowClobber -Force

        ##  if not exists create resource folder.
        if (-not (Test-Path -Path $vstsParams.path)) {
            New-Item -ItemType directory -Path $vstsParams.path -Force | Out-Null
        }

        ##  build resource file path.
        $file = Join-Path $vstsParams.path $(Split-Path $vstsParams.agent -Leaf)

        ##  download vsts-agent
        $Webclient = [Net.WebClient]::New()
        if ($vstsParams.proxy) {
            $Webclient.Proxy = [Net.WebProxy]::New($vstsParams.proxy)
        }
        $Webclient.DownloadFile($vstsParams.agent, $file)

        ##  extract zip file.
        Expand-Archive $file -DestinationPath $vstsParams.vsts -Force
        Write-Verbose "Extracted $(Split-Path $file -Leaf) to $($vstsParams.vsts)."

        ##  get machine metadata.
        <#
        $uri = "169.254.169.254/latest/meta-data"
        $tags = @(
            "aws_ami=$((Invoke-WebRequest $uri/ami-id).Content)"
            "aws_az=$((Invoke-WebRequest $uri/placement/availability-zone).Content)"
            "iam_instance_profile=$(((Invoke-WebRequest $uri/iam/info).Content | ConvertFrom-Json).InstanceProfileArn)"
            "aws_id=$((Invoke-WebRequest $uri/instance-id).Content)"
            "aws_type=$((Invoke-WebRequest $uri/instance-type).Content)"
            "aws_ip=$((Invoke-WebRequest $uri/local-ipv4).Content)"
            "role=$($ServerParams.role)"
            "dns=$($ServerParams.dns)"
        )
        #>

        ##  build install parameters.
        $Install = @{
            FilePath              = "$($vstsParams.vsts)\bin\Agent.Listener.exe"
            ArgumentList          = @(
                "configure"
                "--unattended"
                "--pool $($ServerParams.DeploymentGroup)"
                "--agent $env:COMPUTERNAME"
                "--url https://$($vstsParams.vstsAccount).visualstudio.com"
                "--auth PAT"
                "--token $($vstsParams.token)"
                "--projectname $($vstsParams.vstsProject)"
                "--work $((New-Item $(Join-Path $vstsParams.vsts $vstsParams.workspace) -ItemType directory -Force).FullName)"
                "--runAsService"
                "--windowsLogonAccount `"NT AUTHORITY\SYSTEM`""
                "--replace"
            )
            Wait                  = $true
            NoNewWindow           = $true
            RedirectStandardError = $StdError = [System.IO.Path]::GetTempFileName()
            PassThru              = $true
        }

        Write-Verbose "Processing 'exe' software package: $(Split-Path $($Install.FilePath) -Leaf)."
        $process = Start-Process @Install

        if ($process.ExitCode -ne 0) {
            ## return to catch event.
            Write-Verbose "Failed to install software package: $file."
            if ($null -ne $(Get-Content $StdError)) {
                Write-Verbose $(Get-Content $StdError)
            }
            Return $process.ExitCode
        }
        else {

            Write-Verbose "Completed the install of software package: $(Split-Path $file -Leaf)."

        }

        ##  ALL DONE
        $runtime = [Math]::Round(((Get-Date) - $start).TotalMinutes, 2)
        $response = "Script: $($MyInvocation.MyCommand.Name) complete, total runtime: $("{0:N2}" -f $runtime) minutes."
        Write-Information $response

        ##  return success status $status.
        Return $status

    }
    Catch [System.Exception] {

        Write-Verbose "Error at line: $($PSItem[0].InvocationInfo.line)"
        $message = $PSItem.Exception.GetBaseException().Message
        Throw $message

    }

}
