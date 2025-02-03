### Exercise: Writing Your First Terraform Script
#### Let's create a simple main.tf file to deploy an AWS EC2 instance.
### Exercise: Writing Your First Terraform Script  

Let's create a simple **main.tf** file to deploy an AWS EC2 instance.  

---

#### **Steps to Create the Script**  

1. **Install Terraform**: Ensure Terraform is installed on your system. You can download it from [Terraform's official website](https://www.terraform.io/downloads).  
2. **Set Up AWS CLI**: Configure your AWS credentials using the AWS CLI. Run:  
   ```bash
   aws configure
   ```
3. **Create a Project Folder**: Create a directory to hold your Terraform files.  
   ```bash
   mkdir terraform-example
   cd terraform-example
   ```

4. **Create the `main.tf` File**: Inside your project folder, create a file named `main.tf`.  

---

#### **main.tf**  

```hcl
# Specify the required provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-12345678" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"     # Choose an instance type

  tags = {
    Name = "MyFirstInstance"
  }
}
```

---

#### **Instructions to Execute the Script**  

1. **Initialize the Project**:  
   Run the following command to download the necessary provider plugins:  
   ```bash
   terraform init
   ```

2. **Format and Validate the Script**:  
   Check your script for syntax errors or formatting issues:  
   ```bash
   terraform fmt
   terraform validate
   ```

3. **Preview the Changes**:  
   Use the `plan` command to preview the resources Terraform will create:  
   ```bash
   terraform plan
   ```

4. **Apply the Configuration**:  
   Deploy the resources defined in `main.tf`:  
   ```bash
   terraform apply
   ```
   Confirm with `yes` when prompted.

5. **Verify the Resources**:  
   Log in to your AWS Management Console and check if the EC2 instance is created.

6. **Clean Up**:  
   To delete the resources you created, use:  
   ```bash
   terraform destroy
   ```
   Confirm with `yes` when prompted.

---

Congratulations! 🎉 You've written and executed your first Terraform script! This basic setup can be expanded as you grow familiar with Terraform.