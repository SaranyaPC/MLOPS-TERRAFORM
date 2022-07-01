# company
//variable "company" {
  //type = string
  //description = "This variable defines the name of the company"
//}
# environment
//variable "environment" {
 // type = string
  //description = "This variable defines the environment to be built"
//}
# azure region
variable "location" {
  type = string
  description = "Azure region where resources will be created"
  default = "eastus"
}
//variable "subscription_id" {
  //  description = "The subscription ID to be used to connect to Azure"
    //type = string
//}
//variable "client_id" {
  //  description = "The client ID to be used to connect to Azure"
   // type = string
//}
//variable "client_secret" {
  //  description = "The client secret to be used to connect to Azure"
    //type = string
//}
//variable "tenant_id" {
  //  description = "The tenant ID to be used to connect to Azure"
   // type = string
//}