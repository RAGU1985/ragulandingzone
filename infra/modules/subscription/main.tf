resource "null_resource" "subscription" {

  triggers = {
    "subscription" = "my-subscription-id"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "it works"
    EOT
  }
}

output "subscription_id" {
  value = null_resource.subscription.triggers.subscription
}