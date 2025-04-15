output "ami_id" {
  value = aws_instance.ec2instance.id
}


# The for expression is a powerful way to transform lists or maps in Terraform.
# The join() function is useful for creating human-readable strings from lists.
output "server_tags" {
  description = "Comma-separated list of server tags"
  value       = join(", ", [for tags in var.instance_tags : "server-${tags}"])
}



