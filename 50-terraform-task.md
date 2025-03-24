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

---

### 18. **Create a Lambda Function**
```
provider "aws" {
  region = "us-west-2"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create zip file for Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  
  source {
    content  = <<EOF
exports.handler = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!'),
  };
};
EOF
    filename = "index.js"
  }
}

# Create Lambda function
resource "aws_lambda_function" "hello_lambda" {
  function_name    = "hello-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  timeout     = 10
  memory_size = 128
  
  environment {
    variables = {
      ENVIRONMENT = "dev"
    }
  }
}

```

---
### 19. Install Terraform and verify version

```
terraform -v

```
### 20. Define a local variable

Create a configuration that defines a local variable and outputs its value.

```
locals {
  environment = "development"
}

output "environment" {
  value = local.environment
}

```
### 21. Use input variables

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
### 22. Use resource references

Create an EC2 instance that references the security group created in the previous task.

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP and SSH traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami             = "ami-0c55b159cbfafe1f0"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]
  
  tags = {
    Name = "WebServer"
  }
}

```
### 23. Create a VPC with public and private subnets

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  
  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "MainIGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

```
### 24. Use for_each to create multiple resources with specific names

```
provider "aws" {
  region = "us-west-2"
}

locals {
  instances = {
    web    = "t2.micro"
    app    = "t2.small"
    db     = "t2.medium"
  }
}

resource "aws_instance" "servers" {
  for_each      = local.instances
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value
  
  tags = {
    Name = "${each.key}-server"
  }
}

```

### 25. Use dynamic blocks

```
provider "aws" {
  region = "us-west-2"
}

locals {
  ingress_rules = [
    {
      port        = 80
      description = "HTTP"
    },
    {
      port        = 443
      description = "HTTPS"
    },
    {
      port        = 22
      description = "SSH"
    }
  ]
}

resource "aws_security_group" "web" {
  name        = "web-server-sg"
  description = "Security group for web servers"
  
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.value.description
    }
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
### 26. Deploy an AWS RDS MySQL database

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "db_sg" {
  name        = "mysql-sg"
  description = "Allow MySQL inbound traffic"
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "change-me-please"  # Use secrets manager in production
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  tags = {
    Name = "MySQL-DB"
  }
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}
```
### 27. Deploy an AWS ALB (Load Balancer)

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Public-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "MainIGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  
  tags = {
    Name = "WebALB"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
  health_check {
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_instance" "web" {
  count                  = 2
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  subnet_id              = count.index % 2 == 0 ? aws_subnet.public1.id : aws_subnet.public2.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  user_data              = <<-EOF
                            #!/bin/bash
                            yum update -y
                            yum install -y httpd
                            echo "Hello from instance ${count.index}" > /var/www/html/index.html
                            systemctl start httpd
                            systemctl enable httpd
                            EOF
  
  tags = {
    Name = "WebServer-${count.index + 1}"
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = 2
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

```

### 28  Deploy an AWS Auto Scaling Group

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "Hello from Auto Scaling Group" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
  )
  
  tag_specifications {
    resource_type = "instance"
    
    tags = {
      Name = "WebServer-ASG"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity    = 2
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.public1.id, aws_subnet.public2.id]
  
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "WebASG"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  
  alarm_description = "Scale up if CPU > 80%"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-usage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  
  alarm_description = "Scale down if CPU < 20%"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
```
### 29. Use Terraform workspaces for multiple environments

```
provider "aws" {
  region = "us-west-2"
}

locals {
  environment_config = {
    default = {
      instance_type = "t2.micro"
      instance_count = 1
    }
    dev = {
      instance_type = "t2.micro"
      instance_count = 1
    }
    staging = {
      instance_type = "t2.medium"
      instance_count = 2
    }
    prod = {
      instance_type = "t2.large"
      instance_count = 3
    }
  }

  # Use either the workspace config or default if workspace config doesn't exist
  config = lookup(local.environment_config, terraform.workspace, local.environment_config["default"])
}

resource "aws_instance" "app_server" {
  count         = local.config.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = local.config.instance_type
  
  tags = {
    Name        = "AppServer-${terraform.workspace}-${count.index + 1}"
    Environment = terraform.workspace
  }
}

# Command to use workspaces:
# terraform workspace new dev
# terraform workspace new staging
# terraform workspace new prod
# terraform workspace select dev

```
### 30.  Create an AWS DynamoDB table

```
provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "basic_table" {
  name           = "Users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "CreatedAt"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }

  global_secondary_index {
    name               = "EmailIndex"
    hash_key           = "Email"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "user-table"
    Environment = "dev"
  }

  point_in_time_recovery {
    enabled = true
  }
}

```

### 31. Use Terraform provisioners to execute local commands


```
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  
  tags = {
    Name = "WebServer"
  }

  # Local-exec provisioner runs on the machine executing Terraform
  provisioner "local-exec" {
    command = "echo Instance ${self.id} created with IP ${self.private_ip} > instance_info.txt"
  }

  # This will run when the resource is destroyed
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Instance ${self.id} has been destroyed' >> destruction_log.txt"
  }
}

```
### 32. Create an Azure Virtual Machine with Terraform

```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

```






