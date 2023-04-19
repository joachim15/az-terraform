output "vmName" {
  value = module.virtual_machine.vmName
}
output "computerName" {
  value = module.virtual_machine.computerName
}
#output "sqlServerName" {
 # value = module.sql_server.sqlServerName
#}
#output "mv2DatabaseName" {
 # value = module.sql_server.mv2DatabaseName
#}
#output "oagisDatabaseName" {
#  value = module.sql_server.oagisDatabaseName
#}
#output "sqlProviderDatabaseName" {
 # value = module.sql_server.sqlProviderDatabaseName
#}
output "resourceGroupName" {
  value = module.resource_group.rg_name
}