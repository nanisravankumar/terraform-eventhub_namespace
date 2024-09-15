module "eventhub_namespace" {
  source                        = "./modules/event_hub"
  name                          = var.eventhub_namespace
  location                        = data.azurerm_resource_group.resource_group_name.location
  resource_group_name             = data.azurerm_resource_group.resource_group_name.name
  sku                           = var.sku
  capacity                      = var.capacity
  zone_redundant                = var.zone_redundant
  local_authentication_enabled  = var.local_authentication_enabled
  public_network_access_enabled = var.public_network_access_enabled
  trusted_service_access_enabled = var.trusted_service_access_enabled
  storage_account_name           = data.azurerm_storage_account.storage_account_name.name
  subscription_id               = data.azurerm_client_config.current.subscription_id
  vnet_rg_name                  = var.vnet_rg_name
  vnet_name                     = var.vnet_name
  is_manual_connection          = var.is_manual_connection
  pe_subnet_id                  = data.azurerm_subnet.endpoint_subnet.id
  keyvault_id                   = data.azurerm_key_vault.key_vault_id.id
  eventhub_raw_name             =var.eventhub_raw_name
  authorization_rule            =var.authorization_rule
  consumer_group                =var.consumer_group 
  adaniiotehwriter              =var.adaniiotehwriter 
  eventhub_adaniiotehwriter_auth =var.eventhub_adaniiotehwriter_auth
  adaniiotehwriter_consumer     =var.adaniiotehwriter_consumer
  tags = var.tags
}




