
resource "azurerm_storage_account" "example" {
  name                     = "${var.storagePrefix}storageaccount"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_kind = "StorageV2"
  account_replication_type = var.storageSKU
  enable_https_traffic_only = true

}

