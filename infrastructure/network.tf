# Creating the virtual network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

# Nodes subnet
resource "azurerm_subnet" "nodes" {
  name                 = var.node_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.node_subnet_prefix]
}

# Pods subnet
resource "azurerm_subnet" "pods" {
  name                 = var.pod_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.pod_subnet_prefix]

  # Delegate control of the subnet to Azure Kubernetes Service
  delegation {
    name = "aks-delegation"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}