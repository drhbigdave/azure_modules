variable "workspaces" {
  default = {}
  type = map(object({
    name                              = string
    resource_group_name               = string
    location                          = string
    sku                               = string
    no_public_ip                      = bool
    infrastructure_encryption_enabled = bool
    tags                              = map(string)
    /*
    virtual_network_id                                   = string
    public_subnet_name                                   = string
    public_subnet_network_security_group_association_id  = string
    private_subnet_name                                  = string
    private_subnet_network_security_group_association_id = string
    */
  }))
}
