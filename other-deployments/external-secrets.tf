# Create the Key Vault
resource "azurerm_key_vault" "this" {
  name                        = "${var.secrets_keyvault_name}-${random_string.suffix.result}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  soft_delete_retention_days  = 7
  sku_name                    = "standard"
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create user_assigned_identity
resource "azurerm_user_assigned_identity" "external_secrets" {
  location            = var.location
  name                = var.external_secrets_identity_name
  resource_group_name = var.resource_group_name
}

# Create federated_identity
resource "azurerm_federated_identity_credential" "external_secrets" {
  resource_group_name = var.resource_group_name
  name                = "external-secrets-operator"
  parent_id           = azurerm_user_assigned_identity.external_secrets.id
  issuer              = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject             = "system:serviceaccount:external-secrets:external-secrets"
  audience            = ["api://AzureADTokenExchange"]

  depends_on = [azurerm_user_assigned_identity.external_secrets]
}

# Create Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "external_secrets" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azurerm_user_assigned_identity.external_secrets.principal_id

  key_permissions         = var.env_keyvault_key_permissions
  secret_permissions      = var.env_keyvault_secret_permissions
  storage_permissions     = var.env_keyvault_storage_permissions
  certificate_permissions = var.env_keyvault_certificate_permissions

  depends_on = [azurerm_user_assigned_identity.external_secrets]
}

# Creates the external-secrets namespace
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

# External-secrets helm deployment
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  chart            = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  create_namespace = true
  namespace        = "external-secrets"

  values = [
    templatefile("${abspath(path.root)}/other-deployments/values/eso.yaml", {
      azure_tenant_id                  = data.azurerm_subscription.current.tenant_id
      user_assigned_identity_client_id = azurerm_user_assigned_identity.external_secrets.client_id
    })
  ]
  depends_on = [kubernetes_namespace.external_secrets, azurerm_user_assigned_identity.external_secrets]
}

# Create a cluster secret store
resource "kubectl_manifest" "azure_cluster_secret_store" {
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: azure-clustersecretstore
spec:
  provider:
    azurekv:
      authType: WorkloadIdentity
      vaultUrl: "${azurerm_key_vault.this.vault_uri}"
YAML

  depends_on = [helm_release.external_secrets]
}