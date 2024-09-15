data "azurerm_storage_account" "storage_account_name" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.resource_group_name.name
}
data "azurerm_resource_group" "resource_group_name" {
  name = var.resource_group_name
}