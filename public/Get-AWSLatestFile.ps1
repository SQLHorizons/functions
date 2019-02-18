function Get-AWSLatestFile {

    [CmdletBinding()]
    [OutputType([backups])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $restoreDef
    )

    Try {

        if ($(Split-Path $path -Leaf) -eq $restoreDef.Database) {

            $ReadFiles = @{
                Region     = $restoreDef.Region
                BucketName = $restoreDef.Bucket
                ##  assumes we are using backup paths from ola.hallengren process
                KeyPrefix  = Split-Path $restoreDef.Path
            }

            ##  add credential if no IAM role.
            if ($global:AWSToken) {
                $ReadFiles.Credential = $global:AWSToken
            }

            ##  get a collection of all backups of the database.
            Write-Output "VERBOSE: List backup files in: $($ReadFiles.BucketName)/$($ReadFiles.KeyPrefix)."
            $AllBackups = (Get-S3Object @ReadFiles).Where{ [IO.Path]::GetExtension($_.Key)}

            ##  initialise backups class.
            $Backups = [backups]::New()

            foreach ($Type in @("FULL", "DIFF", "LOG")) {

                ##  get the last backup 'Type' of the database.
                Write-Output "VERBOSE: Listing backups of type: $Type"
                $BackupType = @{
                    Name  = "Last$Type"
                    Force = $true
                }

                switch ($Type) {
                    "FULL" {
                        ##  Full Backup.
                        $BackupType.Value = $AllBackups.Where{
                            [IO.Path]::GetFileNameWithoutExtension($_.Key) -like "*_FULL_*"
                        } | Sort-Object LastModified -Descending |
                            Select-Object -First 1
                    }
                    "DIFF" {
                        ##  DIFF.
                        $BackupType.Value = $AllBackups.Where{
                            [IO.Path]::GetFileNameWithoutExtension($_.Key) -like "*_DIFF_*" -and
                            $_.LastModified -ge $timeStamp
                        } | Sort-Object LastModified -Descending |
                            Select-Object -First 1
                    }
                    "LOG" {
                        ##  LOG.
                        $BackupType.Value = $AllBackups.Where{
                            [IO.Path]::GetFileNameWithoutExtension($_.Key) -like "*_LOG_*" -and
                            $_.LastModified -ge $timeStamp
                        }
                    }
                    default {
                        ##  should not be possible, throw error.
                    }
                }

                ##  create new variable for backup type.
                New-Variable @BackupType

                if (![string]::IsNullOrEmpty($(Get-Variable $BackupType.Name -ValueOnly))) {

                    foreach ($Value in $(Get-Variable $BackupType.Name -ValueOnly)) {

                        ##  set the path and file for the database backup.
                        $Backups.Insert(
                            $(Split-Path $Value.Key),
                            $(Split-Path $Value.Key -Leaf),
                            ([ValidatedType]::New($Type)).Value,
                            $Value.LastModified,
                            "$($SQLServer.BackupDirectory)\$env:COMPUTERNAME\$($restoreDef.Database)\$Type"
                        )

                        ##  get timestamp of backup.
                        $timeStamp = [DateTime]$Value.LastModified

                    }

                }

                ##  destroy variable for backup type.
                Remove-Variable $BackupType.Name -Force

            }

        }
        else {

            ##  if the parent directory is not the database name then throw error.
            $message = "Incorrect path format, the backup path MUST be a format of ../../<database>/FULL"
            Throw $message

        }

        ##  $restoreDef.BackupFile = $($Backups | Where-Object {$_.Type -eq "FULL"} | Select-Object BackupFile).BackupFile

        ##  ALL DONE
        ##  Return $restoreDef
        Return $Backups

    }
    Catch [System.Exception] {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }

}
