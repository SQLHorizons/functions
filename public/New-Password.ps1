function New-Password {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [OutputType([SecureString])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateRange(16, 36)]
        [System.Uint16]
        $length = 36
    )

    Try {

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {

            ##  set character range.
            $Parameters = @{
                Count       = $length
                InputObject = 33..33 + 48..57 + 63..64 + 65..90 + 97..122
            }

            ##  set index.
            $index = 1

            foreach ($value in Get-Random @Parameters) {

                switch ($index) {
                    {$_ -in 9, 14, 19, 24} { $string += "-" }
                    default { $string += [char]$value }
                }
                $index += 1
            }

        }

        ##  ALL DONE

        Return [SecureString]($string|ConvertTo-SecureString -AsPlainText -Force)

    }
    Catch [System.Exception] {

        Write-Verbose "Error at line: $(($PSItem[0].InvocationInfo.line).Trim())"
        $PSCmdlet.ThrowTerminatingError($PSItem)

    }
}
