# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Key Vault with VNET binding and Private Endpoint


resource "azurerm_key_vault" "aml_kv" {
  count = 1
  name                = "mlopstemplatekv${lower(random_id.suffix.hex)}"
 // location            = azurerm_resource_group.aml_rg.location
  //resource_group_name = azurerm_resource_group.aml_rg.name
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  network_acls {
    default_action = "Deny"
    ip_rules       = []
    virtual_network_subnet_ids = [azurerm_subnet.aml_subnet.id, azurerm_subnet.compute_subnet.id]
    bypass         = "AzureServices"
  }
}

# DNS Zones

resource "azurerm_private_dns_zone" "kv_zone" {
  count                    = 1
  name                = "privatelink.vaultcore.azure.net"
  //resource_group_name = azurerm_resource_group.aml_rg.name
 //location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
}

# Linking of DNS zones to Virtual Network

resource "azurerm_private_dns_zone_virtual_network_link" "kv_zone_link" {
  count                    = 1
  name                  = "${random_string.postfix.result}_link_kv"
 //resource_group_name   = azurerm_resource_group.aml_rg.name
  //location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  private_dns_zone_name = azurerm_private_dns_zone.kv_zone.name
  virtual_network_id    = azurerm_virtual_network.aml_vnet.id
}

# Private Endpoint configuration

resource "azurerm_private_endpoint" "kv_pe" {
  count                    = 1
  name                = "${var.prefix}-kv-pe-${random_string.postfix.result}"
 //location            = azurerm_resource_group.aml_rg.location
  //resource_group_name = azurerm_resource_group.aml_rg.name
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  subnet_id           = azurerm_subnet.aml_subnet.id

  private_service_connection {
    name                           = "${var.prefix}-kv-psc-${random_string.postfix.result}"
    private_connection_resource_id = azurerm_key_vault.aml_kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-kv"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv_zone.id]
  }
}