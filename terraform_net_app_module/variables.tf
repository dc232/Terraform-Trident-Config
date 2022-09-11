variable "netapp_address_prefixes" {
    type = list(string)
    default = ["10.1.1.0/24"]
}

######### NetApp Vars #############
variable "namespace" {
  type = string
  default = "netapp"
}

variable "allow_volume_exspansion" {
  type        = bool
  default     = true
  description = "increase volume size for pvs"
}

variable "servicelevel" {
    type = string
    default = "Premium"
}

variable "storageclass" { }

variable "persistence_size" { }
variable "max_persistence_size" { }
variable "debugval" {
  type = bool
  default = "true"
}

variable "netapp_enabled" {
  type = bool
  default = "false"
}

variable "virtual_network_name" {
  type = string
}

variable "netapp_subnetname" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}