# Create user_assigned_identity
resource "azurerm_user_assigned_identity" "aks_dns_identity" {
  name                = "aks-dns-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Create federated identity
resource "azurerm_federated_identity_credential" "default" {
  name                = "external-dns"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_dns_identity.id
  subject             = "system:serviceaccount:external-dns:external-dns"
}

# Create role assignments
resource "azurerm_role_assignment" "aks_dns_role_assignment" {
  scope                = data.azurerm_dns_zone.aks_dns_zone.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_dns_identity.principal_id
}

resource "azurerm_role_assignment" "aks_rg_reader_role_assignment" {
  scope                = data.azurerm_resource_group.dns_zone_rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aks_dns_identity.principal_id
}

# external-dns helm deployment
resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  create_namespace = true
  namespace        = "external-dns"

  values = [
    templatefile("${abspath(path.root)}/other-deployments/values/dns.yaml", {
      azure_subscription_id  = data.azurerm_subscription.current.subscription_id
      azure_tenant_id        = data.azurerm_subscription.current.tenant_id
      external_dns_client_id = azurerm_user_assigned_identity.aks_dns_identity.client_id
      azure_resource_group   = var.dns_resource_group_name
    })
  ]
}
