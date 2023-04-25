# The azurerm_subscription resource represents the subscription alias that is being created.
resource "azurerm_subscription" "this" {
  for_each = var.subscriptions
  # count             = var.subscription_alias_enabled ? 1 : 0
  subscription_name = each.value["subscription_name"]
  alias             = each.value["alias"]
  billing_scope_id  = var.subscription_billing_scope
  workload          = each.value["workload"]
  tags              = each.value["tags"]

  # This provisioner requires az cli to be installed and logged in.
  provisioner "local-exec" {
    when       = destroy
    command    = "az resource delete --ids /subscriptions/${self.subscription_id}/resourceGroups/NetworkWatcherRG"
    on_failure = continue
  }
}