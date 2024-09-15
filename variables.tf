variable "tags" {
  default = {
    Application = "iIC",
    BU = "IC",
    Classification = "Silver",
    Criticality = "Low",
    Env = "QA",
    Owner = "Shah",
    Role = "Application",
    IAC = "Terraform"
  }
  type    = map(string)
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_rg_name" {
  type = string
}

variable "pe_subnet_name" {
  type = string
}




variable "key_vault_name" {
  type = string
}

variable "storage_account_name" {}

variable "eventhub_namespace" {
  type = string
}

variable "trusted_service_access_enabled" {}

variable "is_manual_connection" {}
variable "sku"{}                           
variable "capacity" {}                      
variable "zone_redundant" {}              
variable "local_authentication_enabled"  {} 
variable  "public_network_access_enabled"  {} 
variable "eventhub_raw_name" {}
variable "authorization_rule" {}
variable "consumer_group" {}
variable "iotehwriter" {}
variable "eventhub_iotehwriter_auth" {} 
variable "iotehwriter_consumer" {}
variable "subscription_id" {}
variable "monitor_action_group_name" {}

