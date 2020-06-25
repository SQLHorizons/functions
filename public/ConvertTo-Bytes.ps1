function ConvertTo-Bytes {
    [CmdletBinding()]
    [OutputType([System.Int64])]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidatePattern("[. 0-9]+(B|KB|MB|GB|TB|PB)", Options = "None")]
        [System.String]
        $InputObject
    )

    Try {
        switch ( $($InputObject -replace "[0-9]","") ) {
            "B"  { $Result = [Int64]$InputObject.Replace("B","")  * 1 }
            "KB" { $Result = [Int64]$InputObject.Replace("KB","") * 1KB }
            "MB" { $Result = [Int64]$InputObject.Replace("MB","") * 1MB }
            "GB" { $Result = [Int64]$InputObject.Replace("GB","") * 1GB }
            "TB" { $Result = [Int64]$InputObject.Replace("TB","") * 1TB }
            "PB" { $Result = [Int64]$InputObject.Replace("PB","") * 1PB }
        }

        ##  ALL DONE
        Return $Result
    }
    Catch [System.Exception] {
        Write-Verbose "Error at line: $(($PSItem[0].InvocationInfo.line).Trim())"
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}

<#
    .SYNOPSIS
        Integer with Multiplier Suffix converted to bytes.
        
    .DESCRIPTION
        String input of pattern [. 0-9]+(B|KB|MB|GB|TB) is converted to 64-bit integer,
        expressing the byte equivalent.

    .PARAMETER InputObject
        String input of pattern [. 0-9]+(B|KB|MB|GB|TB), for example: 1GB, 50MB, 20KB, 5TB. 10B.

    .INPUTS
        System.String.

    .OUTPUTS
        System.Int64.

    .EXAMPLE
        PS> "1MB" | ConvertTo-Bytes
        1048576

    .LINK
        https://raw.githubusercontent.com/SQLHorizons/functions/master/public/ConvertTo-Bytes.ps1
#>
