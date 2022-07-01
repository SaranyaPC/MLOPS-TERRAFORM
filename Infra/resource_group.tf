# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

resource "azurerm_resource_group" "aml_rg" {
  //name     = ${resource_group}
  //count    = 2
  //count = ${deploy_acr} 
  //name     = ${resource_group}-${count.index}
  count = 1  
  name     = "rg00-${count.index}"
 // name     = azurerm_resource_group.aks_subnet[count.index].id
  location = ${location}
}

//data "azurerm_resource_group" "aml_rg" {
  // name     = var.resource_group
//}
   