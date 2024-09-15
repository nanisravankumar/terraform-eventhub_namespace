data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "resource_group_name" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_subnet" "endpoint_subnet" {
  name                 = var.pe_subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
}

data "azurerm_key_vault" "key_vault_id" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.resource_group_name.name
}

data "azurerm_storage_account" "storage_account_name" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.resource_group_name.name
}

data "azurerm_monitor_action_group" "email_alert" {
  resource_group_name = data.azurerm_resource_group.resource_group_name.name
  name                = var.monitor_action_group_name
}


 