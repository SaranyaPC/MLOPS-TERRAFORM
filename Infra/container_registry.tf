# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Azure Container Registry (no VNET binding and/or Private Link)

resource "azurerm_container_registry" "mlops_template_acr" {
  count                    = 1
  name                     = "mlopstemplateacr${lower(random_id.suffix.hex)}"
  //resource_group_name      = azurerm_resource_group.aml_rg.name
  //location                 = azurerm_resource_group.aml_rg.location
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  sku                      = "Standard"
  admin_enabled            = true

   //identity {
    //type = "SystemAssigned"
  //}
  
  //network_profile {
    //network_plugin     = "azure"
    //dns_service_ip     = "10.0.3.10"
    //service_cidr       = "10.0.3.0/24"
	  //docker_bridge_cidr = "172.17.0.1/16"
  //}  
  
  //provisioner "local-exec" {
    //command = "az ml computetarget attach aks -n ${azurerm_kubernetes_cluster.aml_aks[count.index].name} -i ${azurerm_kubernetes_cluster.aml_aks[count.index].id} -g ${var.resource_group} -w ${azurerm_machine_learning_workspace.aml_ws.name}"
  //}
  
  //depends_on = [azurerm_machine_learning_workspace.aml_ws]
}