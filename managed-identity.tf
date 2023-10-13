provider "azurerm" {
  subscription_id            = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  skip_provider_registration = "true"
  features {}
  alias = "managed_identity_infra_sub"
}

resource "azurerm_user_assigned_identity" "managed_identity" {
  provider            = azurerm.managed_identity_infra_sub
  name                = "${var.product}-${var.mi_env}-mi"
  resource_group_name = "managed-identities-${var.mi_env}-rg"
  location            = var.location
  tags                = module.tags.common_tags
}

resource "azurerm_key_vault_access_policy" "managed_identity_access_policy" {
  key_vault_id = module.azurekeyvault.key_vault_id

  object_id = azurerm_user_assigned_identity.managed_identity.principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  key_permissions = [
    "Get",
    "List",
  ]

  certificate_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
}