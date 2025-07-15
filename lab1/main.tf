
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  environment_prefix = "${var.application_name}-${var.environment_name}-${random_string.suffix.result}"
  min_nodes          = 5
  max_nodes          = 10
}

module "regionA" {
  source         = "./modules/regional-stamp"
  region         = var.regions[0]
  name           = "foo"
  min_node_count = 4
  max_node_count = 8
}

module "regionB" {
  source         = "./modules/regional-stamp"
  region         = var.regions[1]
  name           = "bar"
  min_node_count = 4
  max_node_count = 8
}
