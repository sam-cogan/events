
provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

module "storage" {
  source              = "./storage"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  storagePrefix       = "stg"
  storageSKU          = "LRS"
}
  
