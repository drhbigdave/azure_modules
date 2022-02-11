resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}

output "resource_group" {
  value = azurerm_resource_group.rg1
}
