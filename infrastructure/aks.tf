# cluster configuration
resource "azurerm_kubernetes_cluster" "this" {
  name                      = var.aks_cluster_name
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  kubernetes_version        = var.kubernetes_version
  dns_prefix                = var.aks_cluster_name
  sku_tier                  = var.sku_tier
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # creating the default node pool
  default_node_pool {
    name                = var.node_name
    node_count          = var.node_count
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_count : null
    max_count           = var.enable_auto_scaling ? var.max_count : null
    vm_size             = var.vm_size
    os_sku              = "AzureLinux"
    vnet_subnet_id      = azurerm_subnet.nodes.id
    pod_subnet_id       = azurerm_subnet.pods.id
    os_disk_type        = var.os_disk_type
    os_disk_size_gb     = var.os_disk_size_gb
  }

  identity {
    type = "SystemAssigned"
  }

  # configuring cilium for network policies
  network_profile {
    network_plugin     = "azure"
    network_policy     = "cilium"
    network_data_plane = "cilium"
  }

  # enabling azuread rbac
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.aks_admins.object_id]
  }

  # enable monitoring and metrics collection
  monitor_metrics {}

}
