data "azurerm_client_config" "current" {}

module "network" {
  source         = "c45/network/bestrong"
  version        = "1.0.0"
  resource_group = azurerm_resource_group.this.name
  location       = azurerm_resource_group.this.location
  env_name       = terraform.workspace
}

module "app" {
  source         = "c45/app/bestrong"
  version        = "1.0.0"
  resource_group = azurerm_resource_group.this.name
  location       = azurerm_resource_group.this.location
  plan_name      = "${terraform.workspace}bestrongserviceplan"
  plan_sku       = "S1"
  app_name       = "${terraform.workspace}bestrongapp"
  subnet_id      = module.network.integration_subnet_id

  storage_account_name = azurerm_storage_account.this.name
  storage_account_key  = azurerm_storage_account.this.primary_access_key
  fileshare_name       = azurerm_storage_share.fileshare.name

  env_name = terraform.workspace
}
