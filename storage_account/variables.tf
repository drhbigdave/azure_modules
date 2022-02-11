resource "azurerm_storage_account" "sa1" {
  count                             = var.datalake_sa_count
  name                              = "${var.datalake_sa_name_prefix}${var.datalake_sa_name_tag}"
  resource_group_name               = var.datalake_rg
  location                          = var.datalake_sa_location
  account_kind                      = var.datalake_sa_kind
  is_hns_enabled                    = var.datalake_sa_is_hns_enabled #this makes an adls gen2 account
  account_tier                      = var.datalake_sa_account_tier
  account_replication_type          = var.datalake_sa_account_replication_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  enable_https_traffic_only         = true
  min_tls_version                   = "TLS1_2"
  allow_blob_public_access          = false

  network_rules {
    default_action             = var.network_rules_default_action
    ip_rules                   = var.firewall_ip_rules_list
    virtual_network_subnet_ids = var.firewall_vnet_subnet_ids
    bypass                     = var.firewall_network_rule_bypass_list
  }
  /*
  #not available in mag for hns att
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
*/
  tags = {
    datalake                     = var.datalake_bool_tag
    sensitivity                  = var.sensitivity_tag
    data_source_uri              = var.data_source_uri_tag
    resource_git_url             = var.resource_git_url_tag
    data_generator               = var.data_generator_description_tag
    data_source                  = var.data_source_tag
    data_source_poc              = var.data_source_poc_tag
    data_source_poc_contact_info = var.data_source_poc_contact_info_tag
    data_source_container        = var.data_source_container_name_tag
    Environment                  = var.environment_tag
    CostCenter                   = var.costcenter_tag
    AppName                      = var.appname_tag
    Customer                     = var.customer_tag
    Requestor                    = var.requestor_tag
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_management_lock" "datalake_sa_lock" {
  count      = var.storage_account_lock_count
  name       = join("-", [azurerm_storage_account.datalake_sa[count.index].name, "lock"])
  scope      = azurerm_storage_account.datalake_sa[count.index].id
  lock_level = "CanNotDelete"
  notes      = "to protect the data lake SAs"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "datalake_sa_file_system1" {
  count              = length(var.datalake_sa_filesystem_names)
  name               = element(var.datalake_sa_filesystem_names, count.index)
  storage_account_id = azurerm_storage_account.datalake_sa[0].id

  lifecycle {
    prevent_destroy = true
  }
}
## below is not ideal, having a second resource to create silver/bronze tiers, but 
## changing the indexing will delete existing containers

resource "azurerm_storage_data_lake_gen2_filesystem" "datalake_sa_file_system2" {
  for_each           = toset(local.nested_filesystem_names)
  name               = each.key
  storage_account_id = azurerm_storage_account.datalake_sa[0].id

  lifecycle {
    prevent_destroy = true
  }
}

output "filesystem_names" {
  value = {
    for k, cont in azurerm_storage_data_lake_gen2_filesystem.datalake_sa_file_system1 : k => cont.id
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "delta_tables" {
  for_each           = toset(var.datalake_sa_delta_filesystems_names)
  name               = each.key
  storage_account_id = azurerm_storage_account.datalake_sa[0].id

  lifecycle {
    prevent_destroy = true
  }
}

output "delta_lake_filesystem_names" {
  value = {
    for k, cont in azurerm_storage_data_lake_gen2_filesystem.delta_tables : k => cont.id
  }
}
resource "azurerm_storage_container" "datalake_sa_containers" {
  for_each              = toset(local.nested_container_names)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.datalake_sa[0].name
  container_access_type = var.datalake_sa_containers_access_type

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_management_policy" "datalake_sa_mgmt_policy" {
  count              = var.datalake_sa_count
  storage_account_id = azurerm_storage_account.datalake_sa[0].id

  rule {
    name    = "standardTierRule"
    enabled = false #var.standard_tier_rule_enabled
    filters {
      #without flatten it kept interpolating to the element 0
      prefix_match = flatten([var.standard_tier_containers])
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = var.standard_tier_to_cool_after_x_days
        tier_to_archive_after_days_since_modification_greater_than = var.standard_tier_to_archive_after_x_days
        delete_after_days_since_modification_greater_than          = var.standard_delete_after_x_days
      }
      snapshot {
        delete_after_days_since_creation_greater_than = var.standard_delete_snapshot_after_x_days
      }
    }
  }
  rule {
    name    = "nonstandardTierRule"
    enabled = var.nonstandard_tier_rule_enabled
    filters {
      prefix_match = flatten([var.nonstandard_tier_containers])
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = var.nonstandard_tier_to_cool_after_x_days
        tier_to_archive_after_days_since_modification_greater_than = var.nonstandard_tier_to_archive_after_x_days
        delete_after_days_since_modification_greater_than          = var.nonstandard_delete_after_x_days
      }
      snapshot {
        delete_after_days_since_creation_greater_than = var.standard_delete_snapshot_after_x_days
      }
    }
  }
}

