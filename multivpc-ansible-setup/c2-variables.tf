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

# variable "ec2_instance_type" {
#   description = "EC2 Instance Type"
#   type = list(object({
#     role       = string
#     type       = string
#     private_ip = string
#   }))
#   default = [
#     { role = "master", type = "t3.micro", private_ip = "10.0.1.45" },
#     { role = "worker", type = "t3.micro", private_ip = "10.0.1.46" },
#     { role = "worker", type = "t3.micro", private_ip = "10.0.1.47" }
#   ]
# }

variable "ec2_instance_type" {
  type = list(object({
    vpc        = string
    subnet     = string
    type       = string
    private_ip = string
    role       = string
  }))
  default = [
    # Instances for dev-01
    { role = "master", type = "t3.micro", private_ip = "", subnet = "192.168.0.0/24", vpc = "dev-01" },
    { role = "worker1", type = "t3.micro", private_ip = "", subnet = "192.168.1.0/24", vpc = "dev-01" },
    { role = "worker2", type = "t3.micro", private_ip = "", subnet = "192.168.2.0/24", vpc = "dev-01" },

    # Instances for dev-02
    { role = "master", type = "t3.micro", private_ip = "", subnet = "192.168.64.0/24", vpc = "dev-02" },
    { role = "worker1", type = "t3.micro", private_ip = "", subnet = "192.168.65.0/24", vpc = "dev-02" },
    { role = "worker2", type = "t3.micro", private_ip = "", subnet = "192.168.66.0/24", vpc = "dev-02" },

    # Instances for dev-03
    { role = "master", type = "t3.micro", private_ip = "", subnet = "192.168.128.0/24", vpc = "dev-03" },
    { role = "worker1", type = "t3.micro", private_ip = "", subnet = "192.168.129.0/24", vpc = "dev-03" },
    { role = "worker2", type = "t3.micro", private_ip = "", subnet = "192.168.130.0/24", vpc = "dev-03" }
  ]
  validation {
    condition     = alltrue([for k, v in var.ec2_instance_type : v.vpc != ""])
    error_message = "Each EC2 instance must have a valid VPC assigned."
  }
}




variable "vpcs" {
  type = map(object({
    cidr_block = string
    subnets    = list(string)
  }))
  default = {
    dev-01 = {
      cidr_block = "192.168.0.0/18"
      subnets    = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
    }
    dev-02 = {
      cidr_block = "192.168.64.0/18"
      subnets    = ["192.168.64.0/24", "192.168.65.0/24", "192.168.66.0/24"]
    }
    dev-03 = {
      cidr_block = "192.168.128.0/18"
      subnets    = ["192.168.128.0/24", "192.168.129.0/24", "192.168.130.0/24"]
    }
  }
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
