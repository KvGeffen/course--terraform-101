variable "region" {
  description = "The region to deploy resources"
  type        = string
}
variable "name" {
  description = "The name of the resource"
  type        = string
}
variable "min_node_count" {
  description = "Minimum number of nodes"
  type        = number
}
variable "max_node_count" {
  description = "Maximum number of nodes"
  type        = number
}

