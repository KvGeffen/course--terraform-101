variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "environment_name" {
  description = "The name of the environment"
  type        = string
}

variable "api_key" {
  description = "The API key"
  type        = string
  sensitive   = true
}
variable "instance_count" {
  description = "The number of instances to create"
  type        = number
}

variable "enabled" {
  description = "Flag to enable or disable the module"
  type        = bool
}
variable "regions" {
  description = "List of regions to deploy resources"
  type        = list(string)

}
variable "region_instance_count" {
  description = "Map of regions to instance counts"
  type        = map(string)
}
variable "region_set" {
  description = "Set of regions to deploy resources"
  type        = set(string)
}
variable "sku_settings" {
  description = "Settings for SKU"
  type = object({
    kind = string
    tier = string
  })
}
