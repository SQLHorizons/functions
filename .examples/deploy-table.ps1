$TableParams = @{
    Database = "SQLOps"
    Schema   = "dbo"
    Name     = "tblConfig"
    Columns  = @(
        @{
           Name     = "key" 
           Datatype = "NVARCHAR"
           Length   = 24
           
        }
        @{
           Name     = "value" 
           Datatype = "NVARCHAR"
           Length   = 256
        }
    )
    Data     = @{
        Paul   = "Hero"
        Gordon = "Villain"
        Marc   = "Princess"
    }
}

$table = [Microsoft.SqlServer.Management.Smo.Table]::New()
$table.Parent = $SQLServer.Databases[$TableParams.Database]
$table.Name   = $tableparams.Name
$table.Schema = $tableparams.Schema

foreach($columnDef in $tableparams.Columns) {
    $column = [Microsoft.SqlServer.Management.Smo.Column]::New()
    $column.Parent = $table
    $column.Name = $columnDef.Name

    $DataType = [Microsoft.SqlServer.Management.Smo.DataType]::New($columnDef.Datatype)
    $DataType.MaximumLength = $columnDef.Length

    $column.DataType = $DataType
    $table.Columns.Add($column)
}

$table.Create()
$table | Write-SqlTableData -InputData $TableParams.Data
