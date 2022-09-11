#### Netapp network #####
resource "azurerm_subnet" "netapp" {
  name                 = var.netapp_subnetname
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.netapp_address_prefixes

  delegation {
    name = "netapp"

    service_delegation {
      name    = "Microsoft.Netapp/volumes"
    }
  }
}
