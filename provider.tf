provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "postgres_network"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

provider "random" {}

terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }
}
