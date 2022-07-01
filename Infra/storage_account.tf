# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Storage Account with VNET binding and Private Endpoint for Blob and File

resource "azurerm_storage_account" "aml_sa" {
  count                    = 1
  name                     = "mlopstemplatesa${lower(random_id.suffix.hex)}"
 //location                 = azurerm_resource_group.aml_rg.location
  //resource_group_name      = azurerm_resource_group.aml_rg.name
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Virtual Network & Firewall configuration

resource "azurerm_storage_account_network_rules" "firewall_rules" {
 //resource_group_name  = azurerm_resource_group.aml_rg.name
  //location            =  azurerm_resource_group.aml_rg[count.index].location
  count                    = 1
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  storage_account_name = azurerm_storage_account.aml_sa.name

  default_action             = "Deny"
  ip_rules                   = []
  virtual_network_subnet_ids = [azurerm_subnet.aml_subnet.id, azurerm_subnet.compute_subnet.id]
  bypass                     = ["AzureServices"]

  # Set network policies after Workspace has been created (will create File Share Datastore properly)
  depends_on = [azurerm_machine_learning_workspace.aml_ws]
}

# DNS Zones

resource "azurerm_private_dns_zone" "sa_zone_blob" {
  count                    = 1
  name                = "privatelink.blob.core.windows.net"
 //resource_group_name = azurerm_resource_group.aml_rg.name
  //location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
}

resource "azurerm_private_dns_zone" "sa_zone_file" {
  count                    = 1
  name                = "privatelink.file.core.windows.net"
 //resource_group_name = azurerm_resource_group.aml_rg.name
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
}

# Linking of DNS zones to Virtual Network

resource "azurerm_private_dns_zone_virtual_network_link" "sa_zone_blob_link" {
  count                    = 1
  name                  = "${random_string.postfix.result}_link_blob"
 //resource_group_name   = azurerm_resource_group.aml_rg.name
  //location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  private_dns_zone_name = azurerm_private_dns_zone.sa_zone_blob.name
  virtual_network_id    = azurerm_virtual_network.aml_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sa_zone_file_link" {
  count                    = 1
  name                  = "${random_string.postfix.result}_link_file"
  //esource_group_name   = azurerm_resource_group.aml_rg.name
  //location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  private_dns_zone_name = azurerm_private_dns_zone.sa_zone_file.name
  virtual_network_id    = azurerm_virtual_network.aml_vnet.id
}

# Private Endpoint configuration

resource "azurerm_private_endpoint" "sa_pe_blob" {
  count                    = 1
  name                = "${var.prefix}-sa-pe-blob-${random_string.postfix.result}"
  //location            = azurerm_resource_group.aml_rg.location
  //resource_group_name = azurerm_resource_group.aml_rg.name
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  subnet_id           = azurerm_subnet.aml_subnet.id

  private_service_connection {
    name                           = "${var.prefix}-sa-psc-blob-${random_string.postfix.result}"
    private_connection_resource_id = azurerm_storage_account.aml_sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.sa_zone_blob.id]
  }
}

resource "azurerm_private_endpoint" "sa_pe_file" {
  count                    = 1
  name                = "${var.prefix}-sa-pe-file-${random_string.postfix.result}"
 //location            = azurerm_resource_group.aml_rg.location
  //resource_group_name = azurerm_resource_group.aml_rg.name
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  subnet_id           = azurerm_subnet.aml_subnet.id

  private_service_connection {
    name                           = "${var.prefix}-sa-psc-file-${random_string.postfix.result}"
    private_connection_resource_id = azurerm_storage_account.aml_sa.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-file"
    private_dns_zone_ids = [azurerm_private_dns_zone.sa_zone_file.id]
  }
}
