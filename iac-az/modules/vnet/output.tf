output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "pip_id_vm" {
  value = azurerm_public_ip.public_ip_vm.id
}

output "pip_id_sql" {
  value = azurerm_public_ip.public_ip_sql.id
}

output "pip_id_vmtest" {
  value = azurerm_public_ip.public_ip_vmtest.id
}
