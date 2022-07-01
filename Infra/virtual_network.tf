# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Virtual Network definition

resource "azurerm_virtual_network" "aml_vnet" {
  count                    = 1
  name                = "${var.prefix}-vnet-${random_string.postfix.result}"
  address_space       = ["10.0.0.0/16"]
  //location            = azurerm_resource_group.aml_rg.location
  //resource_group_name = azurerm_resource_group.aml_rg.name
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
}

resource "azurerm_subnet" "aml_subnet" {
  count                    = 1
  name                 = "${var.prefix}-aml-subnet-${random_string.postfix.result}"
 // resource_group_name  = azurerm_resource_group.aml_rg.name
  //location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  virtual_network_name = azurerm_virtual_network.aml_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "compute_subnet" {
  count                    = 1
  name                 = "${var.prefix}-compute-subnet-${random_string.postfix.result}"
 //resource_group_name  = azurerm_resource_group.aml_rg.name
 // location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  virtual_network_name = azurerm_virtual_network.aml_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
  enforce_private_link_service_network_policies = false
  enforce_private_link_endpoint_network_policies = false
}


resource "azurerm_subnet" "bastion_subnet" {
  count                    = 1
  name                 = "AzureBastionSubnet"
 //resource_group_name  = azurerm_resource_group.aml_rg.name
  //location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  virtual_network_name = azurerm_virtual_network.aml_vnet.name
  address_prefixes     = ["10.0.10.0/27"]
}