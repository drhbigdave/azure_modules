1. Ensure the ref to version is appropriate.
2. ensure in you have a locals block with your parameter values to create tags:

``` terraform
locals {
  tags = {
    project = "daveloper core infra"
  }
}
``` 

module "core_rg" {
  source = "git::https://github.com/drhbigdave/azure_modules.git//daveloper_infra_modules/resource_group?ref=v0.0.2"

  resource_group_name     = <resource group name>
  resource_group_location = "eastus"
  tags                    = local.tags 
}