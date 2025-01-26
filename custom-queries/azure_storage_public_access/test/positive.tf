resource "azurerm_storage_container" "public" {
  name                  = "public-container"
  storage_account_name  = "examplestorageacc"
  container_access_type = "container"
}