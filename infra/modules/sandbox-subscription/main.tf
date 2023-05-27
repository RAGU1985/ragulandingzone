resource "null_resource" "subscription" {

  triggers = {
    "subscription" = var.subscription_id
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "${var.subscription_id}"
    EOT
  }
}

output "subscription_id" {
  value = null_resource.subscription.triggers.subscription
}