resource "azurerm_databricks_workspace" "this" {
  for_each = var.workspaces

  name                              = format("%s-ws", each.value["name"])
  resource_group_name               = each.value["resource_group_name"]
  location                          = each.value["location"]
  sku                               = each.value["sku"]
  infrastructure_encryption_enabled = each.value["infrastructure_encryption_enabled"]
  managed_resource_group_name       = format("%s-managed-rg", each.value["resource_group_name"])
  tags                              = each.value["tags"]
  # the following 2 configs are for private link enablement, which is in preview
  # and not available in MAG, would need whitelisting
  #public_network_access_enabled = false
  #network_security_group_rules_required = "NoAzureServiceRules"
  # TODO: create a custom_parameters dynamic block with a conditional 
  /*
  custom_parameters {
    no_public_ip                                         = each.value["no_public_ip"]
    virtual_network_id                                   = each.value["virtual_network_id"]
    public_subnet_name                                   = each.value["public_subnet_name"]
    public_subnet_network_security_group_association_id  = each.value["public_subnet_network_security_group_association_id"]
    private_subnet_name                                  = each.value["private_subnet_name"]
    private_subnet_network_security_group_association_id = each.value["private_subnet_network_security_group_association_id"]
  }
  */
}
