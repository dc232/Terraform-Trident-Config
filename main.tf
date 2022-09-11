locals {
 netapp_address_prefixes = ["10.1.1.0/24"]
 netapp_namespace = "netapp"
 allow_volume_exspansion = true
 servicelevel = "Premium"
 storageclass = "storage-class-netapp"
  persistancessize = "100Gi"
  maxpersistancessize = "500Gi"
  debugval = "true"
  netapp_enabled = true
  virtual_network_name = ""
  netapp_subnetname = ""
  resource_group_name = ""
  location = ""
}

module "netapp_build" {
  source = "./terraform_net_app_module"
  netapp_address_prefixes = local.netapp_address_prefixes
  namespace = local.netapp_namespace
  allow_volume_exspansion = local.allow_volume_exspansion
  servicelevel = local.storageclass
  persistence_size = local.persistancessize
  max_persistence_size = local.maxpersistancessize
  debugval = local.debugval
  netapp_enabled = local.netapp_enabled
  virtual_network_name = local.virtual_network_name
  netapp_subnetname = local.netapp_subnetname
  resource_group_name = local.resource_group_name
  location = local.location
}