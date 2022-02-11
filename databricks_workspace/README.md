1. Ensure the ref to version is appropriate.
1. Ensure in you have a locals block with your parameter values to create tags:

``` terraform
locals {
  tags = {
    project = "daveloper core infra"
  }
}
```
1. Standard sku does not support infrastructure encryption. 
1. Currently the network items are commented out but are validated. 
``` terraform
module "databricks_workspace" {
  source = "../../azure_modules/databricks_workspace/"

  workspaces = {
    workspace1 = {
      name                              = <works space name>
      resource_group_name               = module.dbx_rg.resource_group.name #this works with rg in this repo
      location                          = module.dbx_rg.resource_group.location #this works with rg in this repo
      sku                               = "standard" # "standard" or "premium" or "trial"
      no_public_ip                      = false # true or false, pick true for SCC
      infrastructure_encryption_enabled = false # true not supported in standard sku
      tags                              = local.tags # created in you config level module
      # commented out, may make a dynamic block in the future for neatness and readability
      # create data objects as per the example below, placed in the config level module
      /*
      # Secure Cluster Connectivity
      virtual_network_id                                   = data.azurerm_virtual_network.dbx_vnet.id
      public_subnet_name                                   = data.azurerm_subnet.dbx_pub_sub.name
      public_subnet_network_security_group_association_id  = data.azurerm_subnet.dbx_pub_sub.id
      private_subnet_name                                  = data.azurerm_subnet.dbx_pub_sub.name
      private_subnet_network_security_group_association_id = data.azurerm_subnet.dbx_priv_sub.id
      */
    }
  }
}
```
Data objects for SCC (secure cluster connectivity), sometimes called vnet injection:
``` terraform
/*
data "azurerm_virtual_network" "dbx_vnet" {
  name                = "<vnet name>"
  resource_group_name = "<vnet rg name>"
}

data "azurerm_subnet" "dbx_pub_sub" {
  name                 = "inside-dbxpub"
  virtual_network_name = "<vnet name>"
  resource_group_name  = "<vnet rg name>"
}

data "azurerm_subnet" "dbx_priv_sub" {
  name                 = "inside-dbxpriv"
  virtual_network_name = "<vnet name>"
  resource_group_name  = "<vnet rg name>"
}
*/
```