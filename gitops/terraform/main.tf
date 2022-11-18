resource "azurerm_resource_group" "resource_group" {
  name     = "${var.project}-rg"
  location = "${var.location}"
}

resource "azurerm_container_registry" "container_registry" {
  name                = "vanekCR"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = "Basic"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project}-aks"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "${var.dns_prefix}"

  identity {
    type = "SystemAssigned"
  }

  #for_each=var.environment

  default_node_pool {
    name       = "default"
    node_count = "${var.node_count}"
    vm_size    = "${var.vm_size}"
    availability_zones = [ "1", "2", "3" ]
    enable_auto_scaling = var.enable_auto_scaling

    node_labels = {
      
      Environment = "dev"
      Project = "${var.project}"
    }
  }

  kubernetes_version = var.kubernetes_version

  tags = {
    Environment = "dev"
    Project = "${var.project}"
    Name = "${var.project}-aks"
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true
}

