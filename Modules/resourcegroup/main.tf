# #############################################################################
# Resource Group
# #############################################################################
resource "azurerm_resource_group" "this" {
  for_each = var.resource_groups
  name     = each.value["name"]
  location = each.value["location"]
  tags = merge(
    each.value["tags"],
    {
      date = formatdate("HH:mm:ss", timestamp())
    }
  )
}
