data "azurerm_client_config" "this" {}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags?ref=master"
  builtFrom   = var.builtFrom
  environment = var.env
  product     = var.product
}

module "key_vault" {
  source                  = "git::https://github.com/hmcts/cnp-module-key-vault.git?ref=master"
  product                 = var.product
  env                     = var.env
  object_id               = data.azurerm_client_config.this.object_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS Platform Operations"
  create_managed_identity = true
  common_tags             = module.tags.common_tags
}
