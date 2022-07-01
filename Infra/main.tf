# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Azure provide configuration

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

//terraform {
  //backend "azurerm" {
    //resource_group_name = ""
    //storage_account_name = "" 
    //container_name       = "" 
    //key                  = ""  
  //}
//}

data "azurerm_client_config" "current" {}