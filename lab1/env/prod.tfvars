environment_name = "prod"
instance_count   = 7
enabled          = false
regions          = ["us-west-1", "us-east-1"]
region_instance_count = {
  "us-west-1" = 4
  "us-east-1" = 8
}
region_set = ["us-west-1", "us-east-1"]
sku_settings = {
  kind = "Standard"
  tier = "Premium"
}
