# azure_modules
terraform modules for azure resources

#### Daveloper infra modules 
- have some subcription specific configurations that will require modification should you wish to reuse them:
1. the IP addresses for the Storage Account are appended with "/32" so I only needed 1 Azure Key Vault secret for the key vault 
and the storage account. The storage account will not accept a CIDR annotation greater than /30.  
2. The key vault access policies are not particularly repeatable or modifiable as they currently exist. 