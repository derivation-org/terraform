# aks cluster related variables
variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "The AKS cluster resource group name"
  type        = string
}

variable "location" {
  description = "The location"
  type        = string
}

# external dns related variables
variable "domain_name" {
  description = "The name of your domain, example.com"
  type        = string
}

variable "dns_resource_group_name" {
  description = "The name of the resource group where your dns zone resides."
  type        = string
}

# external secrets operator related variables
variable "secrets_keyvault_name" {
  description = "External secrets operator keyvault name"
  type        = string
}

variable "external_secrets_identity_name" {
  description = "The name for external secrets identity"
  type = string
}

variable "env_keyvault_key_permissions" {
  type        = list(string)
  description = "Env key vault key permissions"
  default     = ["Get"]
}
variable "env_keyvault_secret_permissions" {
  type        = list(string)
  description = "Env key vault secret permissions"
  default     = ["Get"]
}
variable "env_keyvault_storage_permissions" {
  type        = list(string)
  description = "Env key vault storage permissions"
  default     = ["Get"]
}
variable "env_keyvault_certificate_permissions" {
  type        = list(string)
  description = "Env key vault certificate permissions"
  default     = ["Get"]
}

# cert-manager related variables
variable "cert_manager_email" {
  description = "The email required for the cert manager cluster-issuer"
  default = "example@gmail.com"
  type = string
}
