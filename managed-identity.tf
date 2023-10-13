resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = "${var.product}-${var.mi_env}-mi"
  resource_group_name = "managed-identities-${var.mi_env}-rg"
  location            = var.location
  tags                = module.tags.common_tags
}

resource "azurerm_key_vault_access_policy" "managed_identity_access_policy" {
  key_vault_id = module.key_vault.key_vault_id

  object_id = azurerm_user_assigned_identity.managed_identity.principal_id
  tenant_id = data.azurerm_client_config.this.tenant_id

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