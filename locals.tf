# Define local variables for configuration
locals {

  # The AKS cluster config
  aks_config = {
    aks_cluster_name    = "aks-cluster01"
    resource_group_name = "infra-rg"
    location            = "canadacentral"
    vnet_name           = "aks-vnet"
    vnet_address_space  = ["10.0.0.0/8"]
    node_subnet_name    = "node-subnet"
    node_subnet_prefix  = "10.240.0.0/16"
    pod_subnet_name     = "pod-subnet"
    pod_subnet_prefix   = "10.241.0.0/16"
    sku_tier            = "Free"
    kubernetes_version  = "1.29"
    node_count          = 1
    node_name           = "node0"
    vm_size             = "Standard_D2pls_v5"
    os_disk_size_gb     = 150
    enable_auto_scaling = false
    min_count           = 1 # only apply when auto-scalling = true
    max_count           = 2 # only apply when auto-scalling = true
  }

  # DNS Config
  dns_config = {
    domain_name             = "derivation.space"
    dns_resource_group_name = "dns-zone-rg"
    cert_manager_email      = "example@email.com"
  }

  # External secrets operator config
  external_secrets = {
    secrets_keyvault_name          = "secrets-vault"
    external_secrets_identity_name = "external-secrets-identity"
  }

  # ACR config
  acr_config = {
    acr_name = "acr"
    acr_sku  = "Basic"
  }
}