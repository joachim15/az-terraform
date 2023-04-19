locals {
  
    ,
    var.azure_devops_deploymentgroup,
    var.azure_devops_teamproject,
    "g",
  var.customer_name)



  # SQL authentication mode enable
  sql_authentication = format(<<PS_SCRIPT
  
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
    $s = new-object('Microsoft.SqlServer.Management.Smo.Server') 'HOUGEN002'
    # Change to Mixed Mode
    $s.Settings.LoginMode = [Microsoft.SqlServer.Management.SMO.ServerLoginMode] 'Mixed'
    $s.Alter()
    # Restart SQL Server to apply changes
    Restart-Service -Name 'MSSQLSERVER'

PS_SCRIPT
  )
}