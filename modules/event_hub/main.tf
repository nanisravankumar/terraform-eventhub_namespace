terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  required_version = ">= 0.14.9"
}

resource "azurerm_eventhub_namespace" "namespace" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  capacity                      = var.capacity
  zone_redundant                = var.zone_redundant
  local_authentication_enabled  = var.local_authentication_enabled
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  network_rulesets {
    default_action                 = "Allow"
    public_network_access_enabled  = var.public_network_access_enabled
    trusted_service_access_enabled = var.trusted_service_access_enabled
  }

  identity {
    type = "SystemAssigned"
  }
}

#Assigning role assignment access to ADLS
resource "azurerm_role_assignment" "eventhub_to_adls_access" {
  scope                = data.azurerm_storage_account.storage_account_name.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_eventhub_namespace.namespace.identity.0.principal_id
}

module "eventhub_namespace_private_endpoint" {
  source                         = "../private_endpoint"
  name                           = "${azurerm_eventhub_namespace.namespace.name}PrivateEndpoint"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.pe_subnet_id
  tags                           = var.tags
  private_connection_resource_id = azurerm_eventhub_namespace.namespace.id
  is_manual_connection           = var.is_manual_connection
  subresource_name               = "namespace"
}

