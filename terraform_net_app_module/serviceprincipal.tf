data "azurerm_subscription" "primary" { }

resource "azuread_application" "test" {
  display_name = "netapp-sp"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "test" {
  application_id = azuread_application.test.application_id
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal_password" "test" {
  service_principal_id = azuread_service_principal.test.object_id
}

resource "azurerm_role_assignment" "main" {
  scope                = "${data.azurerm_subscription.primary.id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.test.object_id
}

#https://github.com/hashicorp/terraform-provider-azuread/issues/535
#https://dev.azure.com/dannychauhan/AKS%20private%20version%20for%20dad/_build/results?buildId=548&view=logs&j=275f1d19-1bd8-5591-b06b-07d489ea915a&t=821c94f8-b0a4-5807-b3bb-37203ad06a48