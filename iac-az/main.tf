# 
# Resource Group
# 
module "resource_group" {
  source          = "./modules/resource_group"
  region_location = var.location
  customer_name   = var.customer_name
  instance_suffix = "001" # TBD Make this dynamic 
  tags            = var.tags
}

module "vnet" {
  source                = "./modules/vnet"
  resource_group_name   = module.resource_group.rg_name
  region_location       = var.location
  customer_name         = var.customer_name
  instance_suffix       = "001" # TBD Make this dynamic 
  tags                  = var.tags
  vnet_address_space    = var.vnet_address_space
  snet_address_prefixes = var.snet_address_prefixes
}

# Application insights

module "appi" {
  source              = "./modules/log_analytics"
  resource_group_name = module.resource_group.rg_name
  region_location     = var.location
  customer_name       = var.customer_name
  instance_suffix     = "001" # TBD Make this dynamic 
  tags                = var.tags
}

# Aplocation monitor
module "monitor" {
  source                     = "./modules/monitor"
  resource_group_name        = module.resource_group.rg_name
  region_location            = var.location
  customer_name              = var.customer_name
  log_analytics_workspace_id = module.appi.workspace_id
  emails                     = local.emails
  tags                       = var.tags
}

# KeyVault
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = module.resource_group.rg_name
  region_location     = var.location
  customer_name       = var.customer_name
  certificateConfig   = var.certificateConfig
  tags                = var.tags
}

# VM for application
module "virtual_machine" {
  source                           = "./modules/windows_vm"
  resource_group_name              = module.resource_group.rg_name
  region_location                  = var.location
  customer_name                    = var.customer_name
  instance_suffix                  = "001" # TBD Make this dynamic
  vm_configurations                = local.vm_configurations
  vm_backup_SLA                    = var.vm_backup_SLA == "Standard" ? 8 : 4
  tags                             = var.tags
  subnet_id                        = module.vnet.subnet_id
  public_ip_vm                     = module.vnet.pip_id_vm
  prefix                           = "vm"
  nsg_rules                        = local.nsg_rules_vm
  admin_username                   = var.sql_admin_username
  admin_password                   = var.sql_admin_password
  storage_account_account_tier     = var.storage_account_account_tier
  storage_account_replication_type = var.storage_account_replication_type
  keyvault_settings = {
    keyvault_id = module.keyvault.kv_id
    secret_url  = "${module.keyvault.kv_url}secrets/${module.keyvault.certificate_name}/${module.keyvault.secret_url_version}"
  }

  depends_on = [
    module.vnet,
    module.keyvault
  ]
}

# VM for application
module "virtual_machine_test" {
  source                           = "./modules/windows_vm"
  resource_group_name              = module.resource_group.rg_name
  region_location                  = var.location
  customer_name                    = var.customer_name
  instance_suffix                  = "003" # TBD Make this dynamic
  vm_configurations                = local.vm_configurations
  vm_backup_SLA                    = var.vm_backup_SLA == "Standard" ? 8 : 4
  tags                             = var.tags
  subnet_id                        = module.vnet.subnet_id
  public_ip_vm                     = module.vnet.pip_id_vmtest
  prefix                           = "vmtest"
  nsg_rules                        = local.nsg_rules_vm
  admin_username                   = var.sql_admin_username
  admin_password                   = var.sql_admin_password
  storage_account_account_tier     = var.storage_account_account_tier
  storage_account_replication_type = var.storage_account_replication_type
  keyvault_settings = {
    keyvault_id = module.keyvault.kv_id
    secret_url  = "${module.keyvault.kv_url}secrets/${module.keyvault.certificate_name}/${module.keyvault.secret_url_version}"
  }

  depends_on = [
    module.vnet,
    module.keyvault
  ]
}

# VM for SQL Server
module "virtual_machine_sql" {
  source                           = "./modules/windows_vm"
  resource_group_name              = module.resource_group.rg_name
  region_location                  = var.location
  customer_name                    = var.customer_name
  instance_suffix                  = "002" # TBD Make this dynamic 
  vm_configurations                = local.sql_vm_configurations
  vm_backup_SLA                    = var.vm_backup_SLA == "Standard" ? 8 : 4
  tags                             = var.tags
  subnet_id                        = module.vnet.subnet_id
  public_ip_vm                     = module.vnet.pip_id_sql
  prefix                           = "sql"
  nsg_rules                        = local.nsg_rules_sql
  admin_username                   = var.sql_admin_username
  admin_password                   = var.sql_admin_password
  storage_account_account_tier     = var.storage_account_account_tier
  storage_account_replication_type = var.storage_account_replication_type
  keyvault_settings = {
    keyvault_id = module.keyvault.kv_id
    secret_url  = "${module.keyvault.kv_url}secrets/${module.keyvault.certificate_name}/${module.keyvault.secret_url_version}"
  }

  depends_on = [
    module.vnet
  ]
}

# Currently not used

# module "sql_server" {
#   source                           = "./modules/azure_sql"
#   resource_group_name              = module.resource_group.rg_name
#   region_location                  = var.location
#   customer_name                    = var.customer_name
#   instance_suffix                  = "001" # TBD Make this dynamic 
#   tags                             = var.tags
#   subnet_id                        = module.vnet.subnet_id
#   database_size                    = var.database_size
#   administrator_login              = var.sql_admin_username
#   administrator_login_password     = var.sql_admin_password
#   storage_account_account_tier     = var.storage_account_account_tier
#   storage_account_replication_type = var.storage_account_replication_type
# }
