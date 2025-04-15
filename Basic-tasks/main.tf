# CONFIGURATION AND PARAMETERS
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# # Optionally, you can specify the default version of Terraform to work with
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"    # disable local.tf before enabling this
#       version = "~> 5.0"
#     }
#   }
# }



resource "local_file" "example" {
  content  = "Hello, Terraform!"
  filename = "example.txt"
}



resource "local_file" "files" {
  count    = 3
  content  = "File number ${count.index}"
  filename = "file-${count.index}.txt"
}

locals {
  greeting = "Hello, Terraform!"
}

resource "local_file" "referlocals" {
  content  = local.greeting
  filename = "greeting.txt"
}

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

output "latest_ami_id" {
  value = data.aws_ami.latest.id
}



resource "aws_s3_bucket" "s3bucketcreation" {
  for_each = toset(var.bucket_names)
  bucket   = each.value

}