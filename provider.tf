# Azure Resource Manager Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = false
    }
  }
  
  skip_provider_registration = true # Skips automatic Azure provider registration

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Azure Active Directory Provider
provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}

# Terraform Configuration
terraform {
  required_providers {
    azurerm    = { source = "hashicorp/azurerm", version = ">= 3.0.0" }
    azuread    = { source = "hashicorp/azuread", version = "~> 2.0" }
    helm       = { source = "hashicorp/helm", version = ">= 2.0.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.0.0" }
    kubectl    = { source = "gavinbunney/kubectl", version = ">= 1.14.0" }
    random     = { source = "hashicorp/random", version = ">= 3.0.0" }
    azapi      = { source = "Azure/azapi", version = "=1.7.0" }
  }

# Workspaces
  cloud {
    organization = "derivation"
    workspaces {
      name = "workspace-a"
    }
  }

  required_version = ">= 1.0.0"
}

# Kubernetes Provider
provider "kubernetes" {
  host                   = module.infra.kube_admin_config.host
  client_certificate     = base64decode(module.infra.kube_admin_config.client_certificate)
  client_key             = base64decode(module.infra.kube_admin_config.client_key)
  cluster_ca_certificate = base64decode(module.infra.kube_admin_config.cluster_ca_certificate)
}

# Helm Provider
provider "helm" {
  kubernetes {
    host                   = module.infra.kube_admin_config.host
    client_certificate     = base64decode(module.infra.kube_admin_config.client_certificate)
    client_key             = base64decode(module.infra.kube_admin_config.client_key)
    cluster_ca_certificate = base64decode(module.infra.kube_admin_config.cluster_ca_certificate)
  }
}

# Kubectl Provider
provider "kubectl" {
  host                   = module.infra.kube_admin_config.host
  client_certificate     = base64decode(module.infra.kube_admin_config.client_certificate)
  client_key             = base64decode(module.infra.kube_admin_config.client_key)
  cluster_ca_certificate = base64decode(module.infra.kube_admin_config.cluster_ca_certificate)
  load_config_file       = false
}

# Provider Variables
variable "client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}
