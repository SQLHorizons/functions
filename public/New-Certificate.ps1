function New-Certificate {

    #Requires -RunAsAdministrator
    #Requires -Modules @{ ModuleName="Pester"; ModuleVersion="4.10.1" }

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    [OutputType([System.Security.Cryptography.X509Certificates.X509Certificate2])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $endpoint = "db-live.aws-db-conn.dev.aws-euw1-np.sqlhorizons.com",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $test = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $RemoveFile = $true
    )

    Try {

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {

            ##  if not exist, dot source New-Password.ps1 file.
            if ( ![bool]$(Get-Help New-Password -ErrorAction Ignore) ) {
                . $(Get-ChildItem . -Filter "New-Password.ps1" -Recurse)
            }

            ##  New Self Signed Certificate.
            $SelfSignedCertificate = @{
                CertStoreLocation = "cert:\LocalMachine\My"
                DnsName           = @($endpoint)
            }
            $Certificate = New-SelfSignedCertificate @SelfSignedCertificate

            ##  Export Personal Information Exchange Certificate.
            $global:StoreCertificate = @{
                cert     = "cert:\LocalMachine\My\$($Certificate.Thumbprint)"
                FilePath = [System.IO.Path]::GetTempFileName()
                Password = New-Password
            }
            $PFXfile = Export-PFXCertificate @StoreCertificate

            ##  Import Personal Information Exchange Certificate.
            $StoreCertificate["cert"] = "cert:\LocalMachine\root"
            $X509Certificate = Import-PfxCertificate @StoreCertificate

            if ( [bool] $RemoveFile ) {
                ##  remove temporary file.
                $null = Remove-Item $PFXfile -Force
            }

            if ( [bool]$test ) {

                ##  test ssrs certificate creation was successful.
                Describe "X509Certificate: Integration Checks." {
                    Context "Certificate Creation." {
                        it "Certificate Issuer: should be CN=$env:COMPUTERNAME." {
                            $X509Certificate.Issuer | should -Be "CN=$env:COMPUTERNAME"
                        }
                        it "Certificate Subject: should be CN=$env:COMPUTERNAME." {
                            $X509Certificate.Subject | should -Be "CN=$env:COMPUTERNAME"
                        }
                        it "Certificate Path: should be root." {
                            Split-Path $X509Certificate.PSParentPath -Leaf | should -Be "root"
                        }
                    }
                }

            }

        }

        ##  ALL DONE
        Write-Verbose "Created new certificate for computer: $env:COMPUTERNAME."

        Return $X509Certificate

    }
    Catch [System.Exception] {

        Write-Verbose "Error at line: $(($PSItem[0].InvocationInfo.line).Trim())"
        $PSCmdlet.ThrowTerminatingError($PSItem)

    }
}
