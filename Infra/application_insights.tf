# Copyright (c) 2021 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Application Insights for Azure Machine Learning (no Private Link/VNET integration)

//resource "azurerm_application_insights" "aml_ai" {
  //name                = "${var.prefix}-ai-${random_string.postfix.result}"
  //location            = azurerm_resource_group.aml_rg.location
  //resource_group_name = azurerm_resource_group.aml_rg.name
  //application_type    = "web"
//}
resource "azurerm_application_insights" "mlops_template_ai" {
  count = 1
  name                = "mlopstemplateai${lower(random_id.suffix.hex)}"
  location            =  azurerm_resource_group.aml_rg[count.index].location
  resource_group_name =  azurerm_resource_group.aml_rg[count.index]
  application_type    = "web"
}