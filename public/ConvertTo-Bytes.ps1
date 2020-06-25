function ConvertTo-Bytes {
    [CmdletBinding()]
    [OutputType([System.Int64])]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidatePattern("[. 0-9]+(B|KB|MB|GB|TB)", Options = "None")]
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
        }

        ##  ALL DONE
        Return $Result
    }
    Catch [System.Exception] {
        Write-Verbose "Error at line: $(($PSItem[0].InvocationInfo.line).Trim())"
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
