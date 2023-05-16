# #############################################################################
# Resource Group
# #############################################################################
resource "azurerm_resource_group" "this" {
  for_each = var.resource_groups
  name     = each.value["name"]
  location = each.value["location"]
}

resource "azurerm_resource_group_tag" "this" {
  for_each      = azurerm_resource_group.this
  resource_group_name = each.value.name

  tags = merge(
    each.value.tags,
    {
      date = formatdate("HH:mm:ss", timestamp())
    }
  )
}