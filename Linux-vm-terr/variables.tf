variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "username" {
  type        = string
  description = "The usernam for the local account that will be created on the new VM."
  default     = "azureadmin"
}
