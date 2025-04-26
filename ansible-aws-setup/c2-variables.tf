# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

/* 
# Commented as we are going to get AMI ID from Datasource aws_ami
variable "ec2_ami_id" {
  description = "AMI ID"
  type = string  
  default = "ami-0915bcb5fa77e4892"
}
*/

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type = list(object({
    role       = string
    type       = string
    private_ip = string
  }))
  default = [
    { role = "master", type = "t3.micro", private_ip = "10.0.1.45" },
    { role = "worker", type = "t3.micro", private_ip = "10.0.1.46" },
    { role = "worker", type = "t3.micro", private_ip = "10.0.1.47" }
  ]
}

variable "access_key" {
  description = "Access key to AWS console"
}
variable "secret_key" {
  description = "Secret key to AWS console"
}
variable "region" {
  description = "AWS region"
}

# variable "worker_private_ips" {
#   description = "worker private ip"
# }
