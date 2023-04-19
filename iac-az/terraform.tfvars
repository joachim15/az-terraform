# For Resource group
customer_name = "hougen"
location = "centralus"
# tags = {
#   Environment = "Production"
# }
# For Vnet
vnet_address_space    = "10.0.0.0/16"
snet_address_prefixes = "10.0.2.0/24"
sql_admin_username = "sqldbadmin"
sql_admin_password = "5qldb4m!n#$" #TBD change this to strong password
database_size = 2
storage_account_account_tier = "Standard"
storage_account_replication_type = "LRS"
vm_backup_SLA = "Standard"
#certificateConfig = "any"
certificateConfig = {
    hostName           = "*.mv2mes.com"
    certificateName    = "star.mv2mes.com.pfx"
    certificateIssuer  = "Unknown"
    certificatePasword = "Develop2022-!"
    access_policy = [
      "c8d273e8-b45e-42c0-a6d6-4ad54e94e190", # Yinka
      "e686ba5a-6b34-4ba8-b3df-a34c9cf506c3", # Production Service
    ]
  }

sql_loginType                    = "SqlLogin" # Enables both windows and sql login types