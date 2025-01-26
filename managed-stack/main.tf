# This resource here is to show you how plan policies work.

resource "random_password" "secret" {
  length  = 29
  special = true
}

resource "azurerm_storage_account" "public" {
  name                     = "publicstorageaccount"
  resource_group_name      = "example-resources"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = true
}