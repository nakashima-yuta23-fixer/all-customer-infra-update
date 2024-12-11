resource "azurerm_storage_account" "this" {
  name                     = format("stfxrapp%sdv%s", "${var.customer_name}", "${var.region_code}")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
