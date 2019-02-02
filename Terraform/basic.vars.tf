# vpngw.tf vars

variable "rg_name" {
  description = "Default resource group name that the VPN GW will be created in."
  default     = "terraform"
}

variable "prefix" {
  default = "tfVM"
}

variable "rg_location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "West Europe"
}

variable "ressource_address_space" {
  description = "The vNET CIDR"
  default     = "10.10.0.0/16"
}

variable "default_subnet" {
  description = "The VPN vNET Subnet CIDR"
  default     = "10.10.0.0/24"
}

variable "gw_subnet" {
  description = "The gw vNET Subnet CIDR"
  default     = "10.10.1.0/24"
}

variable "front_subnet" {
  description = "The gw vNET Subnet CIDR"
  default     = "10.10.2.0/24"
}

variable "data_subnet" {
  description = "The gw vNET Subnet CIDR"
  default     = "10.10.3.0/24"
}
