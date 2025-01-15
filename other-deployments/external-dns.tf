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
  version          = "6.28.5"  # Adding specific version to prevent download issues
  create_namespace = true
  namespace        = "external-dns"

  set {
    name  = "provider"
    value = "azure"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "commonLabels.azure\\.workload\\.identity/use"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "serviceAccount.annotations.azure\\.workload\\.identity/client-id"
    value = azurerm_user_assigned_identity.aks_dns_identity.client_id
  }

  set {
    name  = "serviceAccount.labels.azure\\.workload\\.identity/use"
    value = "true"
  }

  set {
    name  = "azure.subscriptionId"
    value = data.azurerm_subscription.current.subscription_id
  }

  set {
    name  = "azure.tenantId"
    value = data.azurerm_subscription.current.tenant_id
  }

  set {
    name  = "azure.resourceGroup"
    value = var.dns_resource_group_name
  }

  set {
    name  = "azure.useWorkloadIdentityExtension"
    value = "true"
  }
}