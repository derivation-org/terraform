# output cluster id and fdqn
output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "aks_cluster_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

# Output the kube admin configuration
output "kube_admin_config" {
  value = {
    host                   = azurerm_kubernetes_cluster.this.kube_admin_config[0].host
    client_certificate     = azurerm_kubernetes_cluster.this.kube_admin_config[0].client_certificate
    client_key             = azurerm_kubernetes_cluster.this.kube_admin_config[0].client_key
    cluster_ca_certificate = azurerm_kubernetes_cluster.this.kube_admin_config[0].cluster_ca_certificate
  }
  sensitive = true
}

# Output the Grafana endpoint URL
output "grafana_endpoint" {
  value = azurerm_dashboard_grafana.this.endpoint
}