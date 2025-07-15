output "environment_prefix" {
  value = local.environment_prefix
}
output "environment_name" {
  value = var.environment_name
}
output "application_name" {
  value = var.application_name
}
output "suffix" {
  value = random_string.suffix.result
}
output "api_key" {
  value     = var.api_key
  sensitive = true
}
output "primary_region" {
  value = var.regions[0]
}
output "primary_region_instance_count" {
  value = var.region_instance_count[var.regions[1]]
}
output "kind" {
  value = var.sku_settings.kind
}
