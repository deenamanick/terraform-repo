### Terraform Remote State Storage & Locking

If you're setting up Terraform with S3 and DynamoDB, update your S3 bucket creation command as follows

## Create the S3 Bucket:

```
aws s3api create-bucket \
  --bucket my-terraform-state-bucket \

```

## Create the DynamoDB Table:

```

aws dynamodb create-table \
  --table-name terraform-lock-table \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1

```
## Update Your Terraform Configuration:

Ensure your main.tf file points to the correct S3 bucket and DynamoDB table:

```
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/my/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
```
## Initialize Terraform:

terraform init
