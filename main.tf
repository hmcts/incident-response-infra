resource "azurerm_resource_group" "rg" {
  name     = "incident-response-rg"
  location = "UK South"
}

resource "random_password" "password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  number  = true
}

data "azurerm_key_vault" "ptl" {
  name                = "cftptl-intsvc"
  resource_group_name = "core-infra-intsvc-rg"
}

resource "azurerm_key_vault_secret" "response-db-secret" {
  name         = "response-db-password"
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.ptl.id
}

resource "azurerm_postgresql_server" "db" {
  name                = "hmcts-incident-response"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "response"
  administrator_login_password = random_password.password.result

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 5120

  backup_retention_days = 7

  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "response" {
  name                = "response"
  resource_group_name = azurerm_postgresql_server.db.resource_group_name
  server_name         = azurerm_postgresql_server.db.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

data "azurerm_subnet" "subnet-00" {
  name                 = "aks-00"
  resource_group_name  = "aks-infra-cftptl-intsvc-rg"
  virtual_network_name = "core-cftptl-intsvc-vnet"
}

resource "azurerm_postgresql_virtual_network_rule" "cluster-access" {
  name                = "aks-00"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.db.name
  subnet_id           = data.azurerm_subnet.subnet-00.id
}
