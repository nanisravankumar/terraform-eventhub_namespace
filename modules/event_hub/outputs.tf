output "name" {
  value = azurerm_eventhub_namespace.namespace.name
}

output "id" {
  value = azurerm_eventhub_namespace.namespace.id
}

output "principal_id" {
  value = azurerm_eventhub_namespace.namespace.identity.0.principal_id
}
