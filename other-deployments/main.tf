# fetching cluster related info
data "azurerm_subscription" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

# fetching DNS related info
data "azurerm_resource_group" "dns_zone_rg" {
  name = var.dns_resource_group_name
}

data "azurerm_dns_zone" "aks_dns_zone" {
  name                = var.domain_name
  resource_group_name = var.dns_resource_group_name
}

# To avoid problems with referencing the providers outside the module
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 1.0.0"
}
