data "azurerm_client_config" "this" {}

module "this" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  product                 = var.product
  env                     = var.env
  object_id               = data.azurerm_client_config.this.object_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS Platform Operations"
  create_managed_identity = true
}
