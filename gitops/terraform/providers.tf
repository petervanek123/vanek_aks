provider "azurerm" {
    tenant_id = var.tenant_id
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
    features {}
    skip_provider_registration = true

}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.32.0"
    }
  }
}