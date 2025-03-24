## Make sure to create the following directory structure, and create the terraform.tvfvars with access key and secret key

```
mkdir project-folder
cd project-folder
touch provider.tf variables.tf terraform.tfvars main.tf output.tf README.md

```
### terraform.tfvars
```
region     = "us-east-1"
access_key = ""
secret_key = ""

```
---

## **Basic Level Tasks**

### 1. **Create an AWS S3 Bucket**
- **Description**: Create a simple S3 bucket in AWS.
- **Code**:
  ```hcl
  provider "aws" {
    region = "us-east-1"
  }

  resource "aws_s3_bucket" "example" {
    bucket = "my-example-bucket-12345"
  }
  ```
- **Recommendation**: Use a unique bucket name to avoid conflicts.

---

### 2. **Create an EC2 Instance**
- **Description**: Launch a basic EC2 instance in AWS.
- **Code**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"
  }
  ```
- **Recommendation**: Use the latest AMI ID for your region.

---

### 3. **Create a Local File**
- **Description**: Generate a local file using Terraform.
- **Code**:
  ```hcl
  resource "local_file" "example" {
    content  = "Hello, Terraform!"
    filename = "example.txt"
  }
  ```
- **Recommendation**: Use this for testing Terraform locally.

---

### 4. **Create a Security Group**
- **Description**: Create an AWS security group with inbound rules.
- **Code**:
  ```hcl
  resource "aws_security_group" "example" {
    name        = "example-sg"
    description = "Allow SSH access"

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ```
- **Recommendation**: Restrict CIDR blocks for production environments.

---

### 5. **Output a Resource Attribute**
- **Description**: Output the public IP of an EC2 instance.
- **Code**:
  ```hcl
  output "public_ip" {
    value = aws_instance.example.public_ip
  }
  ```
- **Recommendation**: Use outputs to retrieve important resource attributes.

---

## **Intermediate Level Tasks**

### 6. **Create a VPC with Subnets**
- **Description**: Create a VPC with public and private subnets.
- **Code**:
  ```hcl
  resource "aws_vpc" "example" {
    cidr_block = "10.0.0.0/16"
  }

  resource "aws_subnet" "public" {
    vpc_id     = aws_vpc.example.id
    cidr_block = "10.0.1.0/24"
  }

  resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.example.id
    cidr_block = "10.0.2.0/24"
  }
  ```
- **Recommendation**: Use modules for complex VPC setups.

---

### 7. **Use Variables**
- **Description**: Use variables to parameterize your Terraform configuration.
- **Code**:
  ```hcl
  variable "instance_type" {
    default = "t2.micro"
  }

  resource "aws_instance" "example" {
    ami           = "ami-0c02fb55956c7d316"
    instance_type = var.instance_type
  }
  ```
- **Recommendation**: Use `variable.tf` for variable values.

---

### 8. **Create an RDS Instance**
- **Description**: Launch an Amazon RDS MySQL instance.
- **Code**:
  ```hcl
  resource "aws_db_instance" "example" {
    allocated_storage    = 20
    engine               = "mysql"
    instance_class       = "db.t2.micro"
    username             = "admin"
    password             = "password"
    skip_final_snapshot  = true
  }
  ```
- **Recommendation**: Use secrets management for sensitive data.

---

### 9. **Use Data Sources**
- **Description**: Fetch the latest AMI ID using a data source.
- **Code**:
  ```hcl
  data "aws_ami" "example" {
    most_recent = true
    owners      = ["amazon"]

    filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
  }

  resource "aws_instance" "example" {
    ami           = data.aws_ami.example.id
    instance_type = "t2.micro"
  }
  ```
- **Recommendation**: Use data sources to avoid hardcoding values.

---

### 10. **Use Count for Multiple Resources**
- **Description**: Create multiple EC2 instances using `count`.
- **Code**:
  ```hcl
  resource "aws_instance" "example" {
    count         = 3
    ami           = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"
  }
  ```
- **Recommendation**: Use `for_each` for more complex scenarios.

---

## **Advanced Level Tasks**

### 11. **Create a Module**
- **Description**: Create a reusable module for an EC2 instance.
- **Code**:
  ```hcl
  # modules/ec2/main.tf
  resource "aws_instance" "example" {
    ami           = var.ami
    instance_type = var.instance_type
  }

  # main.tf
  module "ec2" {
    source        = "./modules/ec2"
    ami           = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"
  }
  ```
- **Recommendation**: Use modules to organize and reuse code.

---

### 12. **Use Terraform Workspaces**
- **Description**: Manage multiple environments using workspaces.
- **Code**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c02fb55956c7d316"
    instance_type = terraform.workspace == "prod" ? "t2.large" : "t2.micro"
  }
  ```
- **Recommendation**: Use workspaces for staging and production environments.

---

### 13. **Use Dynamic Blocks**
- **Description**: Create dynamic security group rules.
- **Code**:
  ```hcl
  variable "ingress_rules" {
    default = [
      { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }

  resource "aws_security_group" "example" {
    dynamic "ingress" {
      for_each = var.ingress_rules
      content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
    }
  }
  ```
- **Recommendation**: Use dynamic blocks for repetitive configurations.

---

### 14. **Use Remote State**
- **Description**: Store Terraform state in an S3 bucket.
- **Code**:
  ```hcl
  terraform {
    backend "s3" {
      bucket = "my-terraform-state"
      key    = "path/to/state"
      region = "us-east-1"
    }
  }
  ```
- **Recommendation**: Enable versioning on the S3 bucket.

---

### 15. **Use Provisioners**
- **Description**: Run a script on an EC2 instance after creation.
- **Code**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"

    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update",
        "sudo apt-get install -y nginx"
      ]
    }
  }
  ```
- **Recommendation**: Use provisioners as a last resort.

---

### 16. **Create an EKS Cluster**
- **Description**: Deploy an Amazon EKS cluster.
- **Code**:
  ```hcl
  module "eks" {
    source          = "terraform-aws-modules/eks/aws"
    cluster_name    = "my-cluster"
    cluster_version = "1.21"
    subnets         = ["subnet-abc123", "subnet-def456"]
  }
  ```
- **Recommendation**: Use community modules for complex setups.

---

### 17. **Use Terraform Cloud**
- **Description**: Integrate Terraform with Terraform Cloud.
- **Code**:
  ```hcl
  terraform {
    cloud {
      organization = "my-org"
      workspaces {
        name = "my-workspace"
      }
    }
  }
  ```
- **Recommendation**: Use Terraform Cloud for collaboration.

---

### 18. **Create a Lambda Function**
- **Description**: Deploy an AWS Lambda function.
- **Code**:
  ```hcl
  resource "aws_lambda_function" "example" {
    function_name = "example-lambda"
    handler       = "index.handler"
    runtime       = "nodejs14.x"
    role          = aws_iam_role.example.arn
    filename      = "lambda.zip"
  }
  ```
- **Recommendation**: Use Terraform to manage serverless architectures.

---
### Install Terraform and verify version

```
terraform -v

```
### Define a local variable

```
Create a configuration that defines a local variable and outputs its value.

```
locals {
  environment = "development"
}

output "environment" {
  value = local.environment
}

```
###  Use input variables

```
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

provider "aws" {
  region = var.region
}

output "environment_info" {
  value = "Running in ${var.environment} environment in ${var.region} region"
}
```




---



---

Let me know if you need further clarification or additional examples!
