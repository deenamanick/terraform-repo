variable "access_key" {
  description = "Access key to AWS console"
  type        = string
}

variable "secret_key" {
  description = "Secret key to AWS console"
  type        = string

}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1" # You can change the default region
}

variable "ami_id" {
  default = "ami-01cc34ab2709337aa" # Replace with latest Ubuntu AMI
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_key_pair" {
  default = "my-key" # Replace with your AWS key pair name
}
