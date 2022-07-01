# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT
### Azure Resource Variables ###

variable "resource_group" {
  type        = list
  default     = ["aml-infra-terraform-poc"]
}

variable "location" {
  default = "East US"
}

variable "aci_cluster_name" {
  default = "aci-cluster"
}

### Suffix for Azure Resource Names ###

resource "random_id" "suffix" {
  byte_length = 3
}

variable "deploy_acr" {
  type = string
  default = "1"
}

//variable "jumphost_username" {
  //default = "azureuser"
//}

//variable "jumphost_password" {
  //default = "ThisIsNotVerySecure!"
//}

variable "prefix" {
  type = string
  default = "amlinfrapoc"
}

resource "random_string" "postfix" {
  length = 6
  special = false
  upper = false
}

variable "subscription_id" {
    description = "The subscription ID to be used to connect to Azure"
    type = string
}
variable "client_id" {
    description = "The client ID to be used to connect to Azure"
    type = string
}
variable "client_secret" {
    description = "The client secret to be used to connect to Azure"
    type = string
}
variable "tenant_id" {
    description = "The tenant ID to be used to connect to Azure"
    type = string
}