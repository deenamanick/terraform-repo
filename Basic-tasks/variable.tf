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

variable "bucket_names" {
  default = ["bucket1001", "bucket2002", "bucket3003"]
}