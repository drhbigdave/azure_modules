variable "resource_group_name" {
  type = string
}
variable "resource_group_location" {
  type    = string
  default = "East US"
}
variable "tags" {
  type    = map(string)
  default = null
}
