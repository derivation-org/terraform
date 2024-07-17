# AKS variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "node_subnet_name" {
  description = "Name of the subnet for AKS nodes"
  type        = string
}

variable "node_subnet_prefix" {
  description = "Address prefix for the node subnet"
  type        = string
  default     = "10.240.0.0/16"
}

variable "pod_subnet_name" {
  description = "Name of the subnet for AKS pods"
  type        = string
}

variable "pod_subnet_prefix" {
  description = "Address prefix for the pod subnet"
  type        = string
  default     = "10.241.0.0/16"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "node_name" {
  description = "The name of the nodes"
  type        = string
  default     = "agent"
}

variable "vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "min_count" {
  description = "Nodes minimum auto-scalling count"
  type        = number
}

variable "max_count" {
  description = "Nodes maximum autos-calling count"
  type        = number
}

variable "enable_auto_scaling" {
  description = "to enable auto-scalling"
  type        = bool
}

variable "os_disk_size_gb" {
  description = "The size of the node disk"
  type        = number
  default     = 32
}
variable "os_disk_type" {
  default = "Managed"
  type    = string
}

variable "sku_tier" {
  description = "The AKS pricing tier"
  default     = "free"
}

# acr variables
variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "acr"
}

variable "acr_sku" {
  description = "The sku of the azure container registry"
  type        = string
  default     = "Basic"
}

# Grafana variables
variable "grafana_sku" {
  description = "The sku for the grafana instance"
  type        = string
  default     = "Essential"
}
