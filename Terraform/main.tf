# Configure the Azure Provider
provider "azurerm" {
    version = "=1.21.0"

    partner_id = "f18c316d-fd02-4fe4-a115-1efc30e3c8fb"
}

terraform {
  backend "azurerm" {
    storage_account_name = "pmtshare"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}