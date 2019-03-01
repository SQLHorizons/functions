#Requires -Version 5.0

##  backup type validation class.
class ValidatedType {
    ##  type of backup.
    [ValidateSet("FULL", "DIFF", "LOG")]
    [System.String]
    $Value

    ValidatedType([string]$String) {
        $this.Value = $String
    }
}

##  class to hold details of the backup files.
class backups:system.Data.DataTable {

    ##  initiate a new instance of the backup table with columns.
    backups() {

        ##  the column definition for the backups table.
        $columnDefs = @{
            id           = "System.Int32"
            Path         = "System.String"
            BackupFile   = "System.String"
            Type         = "System.String"
            LastModified = "System.DateTime"
            Destination  = "System.String"
        }

        ##  loop through the column definitions.
        foreach ($column in $columnDefs.Keys) {

            ##  create data columns.
            $entity = [System.Data.DataColumn]::New(
                $column, $columnDefs[$column]
            )
            if ($column -eq "id") {
                ##  set column to auto increment.
                $entity.AutoIncrement = $true
            }
            $this.columns.add($entity)
        }
    }

    ##  insert a record into the backups table.
    [void] Insert(

        [System.String]
        $Path,

        [System.String]
        $BackupFile,

        [System.String]
        $Type,

        [System.DateTime]
        $LastModified,

        [System.String]
        $Destination = $null

    ) {

        ##  create a new row on 'this' class object.
        $row = $this.NewRow()

        ##  enter data in the row.
        $row.id
        $row.Path = $Path
        $row.BackupFile = $BackupFile
        $row.Type = $Type
        $row.LastModified = $LastModified
        if ($null -ne $Destination) {
            $row.Destination = $Destination
        }

        ##  Add the row to 'this' table.
        $this.Rows.Add($row)

    }

}
