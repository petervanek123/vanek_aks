provider "azurerm" {
    tenant_id = var.tenant_id
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