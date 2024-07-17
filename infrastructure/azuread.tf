# Create AKS Azure AD admin group & assignment
resource "azuread_group" "aks_admins" {
  display_name     = "AKS Cluster Admins"
  security_enabled = true
}

resource "azurerm_role_assignment" "aks_rbac_cluster_admin" {
  principal_id         = azuread_group.aks_admins.object_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = azurerm_kubernetes_cluster.this.id
}

# Create AKS Azure AD contributors group & assignment
resource "azuread_group" "aks_contributors" {
  display_name     = "AKS Cluster Contributors"
  security_enabled = true
}

resource "azurerm_role_assignment" "aks_rbac_contributor" {
  principal_id         = azuread_group.aks_contributors.object_id
  role_definition_name = "Azure Kubernetes Service RBAC Contributor"
  scope                = azurerm_kubernetes_cluster.this.id
}

# Create AKS Azure AD readers group & assignment
resource "azuread_group" "aks_readers" {
  display_name     = "AKS Cluster Readers"
  security_enabled = true
}

resource "azurerm_role_assignment" "aks_rbac_reader" {
  principal_id         = azuread_group.aks_readers.object_id
  role_definition_name = "Azure Kubernetes Service RBAC Reader"
  scope                = azurerm_kubernetes_cluster.this.id
}
