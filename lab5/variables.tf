variable "application_name" {
  description = "The name of the application to be deployed"
  type        = string
}
variable "environment_name" {
  description = "The environment for the application (e.g., dev, prod)"
  type        = string
}
variable "primary_location" {
  description = "The primary location for the resources"
  type        = string

}
variable "base_address_space" {
  description = "The base address space for the virtual network"
  type        = string
}
