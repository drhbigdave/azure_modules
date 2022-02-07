variable "resource_group_name" {}
variable "resource_group_location" {}
variable "storage_account_name" {}
variable "storage_account_kind" {}
variable "storage_account_tier" {}
variable "storage_account_replication_type" {}
variable "enable_https_traffic_only" {
  type    = string
  default = true
}
variable "min_tls_version" {
  type    = string
  default = "TLS1_2"
}
variable "storage_account_allow_blob_public_access" {
  type    = string
  default = false
}
variable "storage_account_is_hns_enabled" {}
variable "storage_account_infrastructure_encryption_enabled" {
  type    = string
  default = true
}
variable "storage_account_network_rules_default_action" {}
variable "storage_account_network_rules_ip_rules" {
  type    = list(string)
  default = []
}
variable "storage_account_network_rules_vnet_subnet_ids" {
  type    = list(string)
  default = []
}
variable "storage_account_network_rules_bypass" {
  type    = list(string)
  default = []
}
variable "storage_container_name" {}
variable "container_access_type" {}
variable "tags" {
  type    = map(string)
  default = null
}
