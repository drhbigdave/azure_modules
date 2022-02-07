resource "azurerm_storage_account" "this" {
  name                              = var.storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.resource_group_location
  account_kind                      = var.storage_account_kind
  account_tier                      = var.storage_account_tier
  account_replication_type          = var.storage_account_replication_type
  enable_https_traffic_only         = true
  min_tls_version                   = "TLS1_2"
  allow_blob_public_access          = var.storage_account_allow_blob_public_access
  is_hns_enabled                    = var.storage_account_is_hns_enabled
  infrastructure_encryption_enabled = var.storage_account_infrastructure_encryption_enabled
  tags                              = var.tags
}

resource "azurerm_storage_account_network_rules" "test" {
  storage_account_id = azurerm_storage_account.this.id
  default_action     = var.storage_account_network_rules_default_action
  ip_rules           = var.storage_account_network_rules_ip_rules
  #virtual_network_subnet_ids = var.storage_account_network_rules_vnet_subnet_ids
  bypass = var.storage_account_network_rules_bypass
}

resource "azurerm_storage_container" "this" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = var.container_access_type
}
