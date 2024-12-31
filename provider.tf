# root module for deployment of resources.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.93.0" # version of the azure provider API
    }
  }

  #  required_version = ">= 1.1.0" # version of terraform used
}

# credentials to access azure to provision resources
provider "azurerm" {
  features {}

  subscription_id = "xxxxxxxx-xxxx"
  tenant_id       = "xxxxxxxx-xxxx"
}
