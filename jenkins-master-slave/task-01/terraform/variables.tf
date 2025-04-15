variable "access_key" {
  description = "Your AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Your AWS secret key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # You can change the default region
}

