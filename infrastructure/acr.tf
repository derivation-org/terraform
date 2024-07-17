# Azure Container Registry configuration
resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}0${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.acr_sku
  admin_enabled       = true
}

# Attach ACR to AKS
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 20
  special = false
  upper   = false
}
