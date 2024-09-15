terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.60"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.9.0"
    }

  }
}

provider "azurerm" {
  features {}
   subscription_id = var.subscription_id
}



