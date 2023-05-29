# Output variables for Resource Group module

output "resource_name" {
  value = [for x in azurerm_resource_group.resource_group : x.id]
  description = "Output name of the created Resource Group"
}