# Creating the resource group
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# Register the following using the cli to avoid errors
# az provider register --namespace Microsoft.Dashboard
# az provider register --namespace Microsoft.ContainerRegistry
# az provider register --namespace Microsoft.Monitor
# az provider register --namespace Microsoft.Insights
# az provider register --namespace Microsoft.ContainerService