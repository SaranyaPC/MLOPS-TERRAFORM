
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}



provider "azurerm" {
  version = "=2.76.0"
  subscription_id = "4f42b499-2307-4b41-836e-29cbf6b5c291"
client_id       = "d0f92f9f-f97c-45de-8621-49ea89610ab4"
client_secret   = "x3z8Q~4j.n1yriI-eUGpmX7s5XbKt31ZalXS~cno"
tenant_id       = "0b8f7cd0-8a41-40eb-abd6-fbf0cecaddb5"
  features {}
}

# Generate a random storage name
resource "random_string" "tf-name" {
  length = 8
  upper = false
  number = true
  lower = true
  special = false
}
# Create a Resource Group for the Terraform State File
resource "azurerm_resource_group" "state-rg" {
  name = "azure-poc-tfstate-rg"
  location = var.location
  
  lifecycle {
    prevent_destroy = true
  }
  //tags = {
    //environment = var.environment
  //}
}
# Create a Storage Account for the Terraform State File
resource "azurerm_storage_account" "state-sta" {
  depends_on = [azurerm_resource_group.state-rg]
  name = "azurepoctf${random_string.tf-name.result}"
  resource_group_name = azurerm_resource_group.state-rg.name
  location = azurerm_resource_group.state-rg.location
  account_kind = "StorageV2"
  account_tier = "Standard"
  access_tier = "Hot"
  account_replication_type = "ZRS"
  enable_https_traffic_only = true
   
  lifecycle {
    prevent_destroy = true
  }
}
# Create a Storage Container for the Core State File
resource "azurerm_storage_container" "core-container" {
  depends_on = [azurerm_storage_account.state-sta]
  name = "core-tfstate"
  storage_account_name = azurerm_storage_account.state-sta.name
}