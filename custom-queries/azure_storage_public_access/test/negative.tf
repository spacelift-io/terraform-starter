resource "azurerm_storage_container" "private" {
  name                  = "private-container"
  storage_account_name  = "examplestorageacc"
  container_access_type = "private"
}