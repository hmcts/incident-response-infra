resource "azurerm_resource_group" "rg" {
  name     = "incident-response-rg"
  location = "UK South"
}

data "azurerm_key_vault" "ptl" {
  name                = var.keyvault_data_name
  resource_group_name = "core-infra-intsvc-rg"
}

module "postgresql_flexible" {
  providers = {
    azurerm.postgres_network = azurerm.postgres_network
  }
  count = var.create_postgres ? 1 : 0

  source                        = "git::https://github.com/hmcts/terraform-module-postgresql-flexible?ref=master"
  env                           = var.env
  product                       = var.product
  name                          = "hmcts-incident-response-flexible"
  component                     = var.component
  business_area                 = "CFT"
  location                      = var.location
  pgsql_admin_username          = "response"
  pgsql_storage_mb              = var.pgsql_storage_mb
  enable_read_only_group_access = false
  common_tags                   = module.tags.common_tags
  admin_user_object_id          = data.azurerm_client_config.this.object_id
  collation                     = "en_US.utf8"
  pgsql_databases = [
    {
      name : "response"
    }
  ]
  pgsql_firewall_rules = []
  pgsql_version        = "14"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_key_vault_secret" "response-db-secret-v14" {
  count = var.create_postgres ? 1 : 0

  name         = "response-db-password-v14"
  value        = module.postgresql_flexible[0].password
  key_vault_id = data.azurerm_key_vault.ptl.id
}
