resource "azurerm_resource_group" "this" {
  name     = format("rg-fixer-app-%s-dv-%s", "${var.customer_name}", "${var.region_code}")
  location = var.location
}
