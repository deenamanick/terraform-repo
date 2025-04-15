# Define Output Values

# Attribute Reference
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  # value       = aws_instance.my-ec2-vm["each.Key"].public_ip
  value = {
    for key, instance in aws_instance.my-ec2-vm : key => instance.public_ip
  }
}

# Attribute Reference - Create Public DNS URL 
output "ec2_publicdns" {
  description = "Public DNS URL of an EC2 Instance"
  # value       = aws_instance.my-ec2-vm["each.key"].public_dns
  value = {
    for key, instance in aws_instance.my-ec2-vm : key => instance.public_ip
  }
}


output "ami_id" {
  value = data.aws_ami.amzlinux.id

}

# output "cidr_blocks_debug" {
#   value = local.limited_cidr_blocks
# }

# # Output worker IPs for debugging
# output "worker_private_ips" {
#   value = local.worker_private_ips
# }

# output "private_key_pem" {
#   value     = tls_private_key.example.private_key_pem
#   sensitive = true # Hides the private key from logs
# }

# output "master_ip" {
#   description = "The private IP of the master instance"
#   value       = local.master_ip
# }

# output "worker_ips" {
#   description = "The private IPs of the worker instances"
#   value       = local.worker_ips
# }