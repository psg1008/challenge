terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "rg-test-aks"
      storage_account_name = "strgtestaks"
      container_name       = "test-aks-infra-terraform-tfstates"
      key                  = "challenge/terraform.tfstate"
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}
