resource "azurerm_monitor_metric_alert" "eventhub_metric_alert" {
  name                = "eventhub-metricalert"
  resource_group_name = data.azurerm_resource_group.resource_group_name.name
  scopes              = [module.eventhub_namespace.id]
  description         = "Eventhub Monitoring alert"

  criteria {
    metric_namespace = "Microsoft.EventHub/Namespaces"
    metric_name      = "ActiveConnections"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = 2
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.email_alert.id
  }

  depends_on = [
    azurerm_monitor_metric_alert.eventhub_metric_alert,
    module.eventhub_namespace
  ]
}
