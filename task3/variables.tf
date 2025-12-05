variable "location" {
  type        = string
  default     = "uksouth"
  description = "The Azure region where the resource group will be created"
}

variable "name" {
  type        = string
  default     = "rg-demo-task3-uksouth-001"
  description = "The name of the resource group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the resource group"
}