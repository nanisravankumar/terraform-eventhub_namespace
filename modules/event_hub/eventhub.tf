/*Event Hub 01 - IOT HUB*/

resource "azurerm_eventhub" "eventhub_raw" {
  name                = var.eventhub_raw_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  message_retention   = 1
  partition_count     = 3
  status              = "Active"

  capture_description {
    enabled  = true
    encoding = "Avro"
    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name = "eventhub01"
      storage_account_id  = data.azurerm_storage_account.storage_account_name.id
    }
  }
}

resource "azurerm_eventhub_authorization_rule" "eventhub_iot" {
  name                = var.authorization_rule                                       #adaniiotstreampolicy
  namespace_name      = azurerm_eventhub_namespace.namespace.name                     #AZ01AEHQA01
  eventhub_name       = azurerm_eventhub.eventhub_raw.name                            #adaniiotehconsumer
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_eventhub_consumer_group" "raw" {
  name                = var.consumer_group 
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.eventhub_raw.name
  resource_group_name = var.resource_group_name
  user_metadata       = "some-meta-data"
}

/*Event Hub 01 - IOT HUB*/

resource "azurerm_eventhub" "eventhub_iiotehwriter" {
  name                = var.iiotehwriter 
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  message_retention   = 1
  partition_count     = 3
  status              = "Active"
}

resource "azurerm_eventhub_authorization_rule" "eventhub_iiotehwriter_auth" {
  name                = var.eventhub_iiotehwriter_auth 
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.eventhub_iiotehwriter.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_key_vault_secret" "eventhub_iot_auth_writer" {
  name         = "adani-ic-eventhub-writer-key"
  key_vault_id = var.keyvault_id
  value        = azurerm_eventhub_authorization_rule.eventhub_iiotehwriter_auth.primary_connection_string
  depends_on   = [azurerm_eventhub_authorization_rule.eventhub_iot]
}

resource "azurerm_key_vault_secret" "eventhub_iot_auth" {
  name         = "adani-ic-eventhub-consumer-key"
  key_vault_id = var.keyvault_id
  value        = azurerm_eventhub_authorization_rule.eventhub_iot.primary_connection_string
  depends_on   = [azurerm_eventhub_authorization_rule.eventhub_iot]
}

resource "azurerm_eventhub_consumer_group" "iiotehwriter_consumer" {
  name                = var.iiotehwriter_consumer 
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.eventhub_iiotehwriter.name
  resource_group_name = var.resource_group_name
  user_metadata       = "some-meta-data"
}
