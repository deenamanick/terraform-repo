# variable "environment" {
#   description = "Environment (e.g., dev, uat)"
#   type        = string
# }

variable "access_key" {
  description = "Access key to AWS console"
  type        = string
}

variable "secret_key" {
  description = "Secret key to AWS console"
  type        = string
  sensitive   = true
}
variable "region" {
  description = "AWS region"
  type        = string
}

