# Register the Microsoft.Dashboard resource provider
# az provider register --namespace Microsoft.Dashboard

# INFRA module - Creates and configures the infrastructure resources
module "infra" {
  source = "./infrastructure"

  aks_cluster_name    = local.aks_config.aks_cluster_name
  resource_group_name = local.aks_config.resource_group_name
  location            = local.aks_config.location
  vnet_name           = local.aks_config.vnet_name
  vnet_address_space  = local.aks_config.vnet_address_space
  node_subnet_name    = local.aks_config.node_subnet_name
  node_subnet_prefix  = local.aks_config.node_subnet_prefix
  pod_subnet_name     = local.aks_config.pod_subnet_name
  pod_subnet_prefix   = local.aks_config.pod_subnet_prefix
  kubernetes_version  = local.aks_config.kubernetes_version
  sku_tier            = local.aks_config.sku_tier
  node_count          = local.aks_config.node_count
  node_name           = local.aks_config.node_name
  min_count           = local.aks_config.min_count
  max_count           = local.aks_config.max_count
  enable_auto_scaling = local.aks_config.enable_auto_scaling
  vm_size             = local.aks_config.vm_size
  os_disk_size_gb     = local.aks_config.os_disk_size_gb
  acr_name            = local.acr_config.acr_name
  acr_sku             = local.acr_config.acr_sku
}

# Other deployments - Manages the deployment on the AKS cluster & related resources
module "other_deployments" {
  source = "./other-deployments"

  aks_cluster_name               = local.aks_config.aks_cluster_name
  resource_group_name            = local.aks_config.resource_group_name
  location                       = local.aks_config.location
  dns_resource_group_name        = local.dns_config.dns_resource_group_name
  domain_name                    = local.dns_config.domain_name
  secrets_keyvault_name          = local.external_secrets.secrets_keyvault_name
  external_secrets_identity_name = local.external_secrets.external_secrets_identity_name
  depends_on                     = [module.infra]
}
