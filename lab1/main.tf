
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  environment_prefix = "${var.application_name}-${var.environment_name}-${random_string.suffix.result}"
  min_nodes          = 5
  max_nodes          = 10

  regional_stamps = [
    {
      region         = "westus"
      name           = "foo"
      min_node_count = 4
      max_node_count = 8
    },
    {
      region         = "eastus"
      name           = "bar"
      min_node_count = 4
      max_node_count = 8
    }
  ]
}

module "regional_stamps" {

  count = length(var.regions)

  source = "./modules/regional-stamp"

  region         = local.regional_stamps[count.index].region
  name           = local.regional_stamps[count.index].name
  min_node_count = local.regional_stamps[count.index].min_node_count
  max_node_count = local.regional_stamps[count.index].max_node_count
}
