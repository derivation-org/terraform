# current client configuration
data "azurerm_client_config" "current" {}

# Azure Monitor workspace
resource "azurerm_monitor_workspace" "this" {
  name                = "amon-${var.aks_cluster_name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

# Data Collection Endpoint for monitoring
resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                = "msprom-${azurerm_resource_group.this.location}-${var.aks_cluster_name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  kind                = "Linux"
}

# Data Collection Rule for Prometheus metrics
resource "azurerm_monitor_data_collection_rule" "this" {
  name                        = "msprom-${azurerm_resource_group.this.location}-${var.aks_cluster_name}"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.this.id

  # Define Prometheus data source
  data_sources {
    prometheus_forwarder {
      name    = "PrometheusDataSource"
      streams = ["Microsoft-PrometheusMetrics"]
    }
  }

  # Set destination to the Azure Monitor workspace
  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.this.id
      name               = azurerm_monitor_workspace.this.name
    }
  }

  # Configure data flow from Prometheus to Azure Monitor
  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = [azurerm_monitor_workspace.this.name]
  }
}

# Associate the Data Collection Rule with the AKS cluster
resource "azurerm_monitor_data_collection_rule_association" "dcr_to_aks" {
  name                    = "dcr-${var.aks_cluster_name}"
  target_resource_id      = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.this.id
}

# Associate the Data Collection Endpoint with the AKS cluster
resource "azurerm_monitor_data_collection_rule_association" "dce_to_aks" {
  target_resource_id          = azurerm_kubernetes_cluster.this.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.this.id
}

# Azure Managed Grafana instance
resource "azurerm_dashboard_grafana" "this" {
  name                = "amg-${var.aks_cluster_name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.grafana_sku

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.this.id
  }
}

# Assign Monitoring Data Reader role to the Grafana managed identity for the Azure Monitor workspace
resource "azurerm_role_assignment" "amon_amg" {
  scope                = azurerm_monitor_workspace.this.id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.this.identity[0].principal_id
}




