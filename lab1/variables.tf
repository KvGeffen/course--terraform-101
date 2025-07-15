variable "application_name" {
  description = "The name of the application"
  type        = string

  validation {
    condition     = length(var.application_name) < 12
    error_message = "Application name must be less than 12 characters."
  }
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

  validation {
    condition = (
      var.instance_count >= local.min_nodes &&
      var.instance_count < local.max_nodes &&
      var.instance_count % 2 != 0
    )
    error_message = "Instance count must be an odd number between 5 and 10."
  }
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
