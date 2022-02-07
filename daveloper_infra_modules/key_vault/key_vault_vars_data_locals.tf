variable "resource_group_name" {}
variable "resource_group_location" {}
variable "key_vault_name" {}
variable "key_vault_network_acls_default_action" {}
variable "key_vault_network_acls_ip_rules" {
  type    = list(string)
  default = []
}
variable "key_vault_network_acls_vnet_subnet_ids" {
  type    = list(string)
  default = []
}
variable "main_account_object_id" {
  sensitive = true
}
variable "tags" {
  type    = map(string)
  default = null
}
