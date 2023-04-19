output "kv_url" {
  value = azurerm_key_vault.kv.vault_uri
}

output "kv_id" {
  value = azurerm_key_vault.kv.id
}

output "kv_secret_id" {
  value = azurerm_key_vault_certificate.kvCertificate.secret_id
}


output "certificate_name" {
  value = azurerm_key_vault_certificate.kvCertificate.name
}

output "secret_url" {
  value = azurerm_key_vault_certificate.kvCertificate.secret_id
}

output "secret_url_version" {
  value = azurerm_key_vault_certificate.kvCertificate.version
}
