# Create Security Group - SSH Traffic - Static method
resource "aws_security_group" "vpc-ssh" {
  name        = "vpc-ssh"
  description = "Dev VPC SSH"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group - Web Traffic
resource "aws_security_group" "vpc-web" {
  name        = "vpc-web"
  description = "Dev VPC web"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# Fetch AWS IP ranges dynamically for US East (N. Virginia) region  -- Dynamic method
data "aws_ip_ranges" "us_east_1" {
  regions  = ["us-east-1"]
  services = ["EC2"]
}

# Limit the number of CIDR blocks strictly to the first 2
# locals {
#   all_cidr_blocks = data.aws_ip_ranges.us_east_1.cidr_blocks
#   # Ensure only the first 2 CIDR blocks are selected
#   limited_cidr_blocks = slice(local.all_cidr_blocks, 0, min(2, length(local.all_cidr_blocks)))
# }

# locals {
#   allowed_cidr_blocks = ["52.95.245.0/24", "52.94.248.0/28"]
# }


# # Create Security Group - SSH Traffic
# resource "aws_security_group" "vpc-ssh" {
#   name        = "vpc-ssh"
#   description = "Dev VPC SSH"

#   dynamic "ingress" {
#     # for_each = data.aws_ip_ranges.us_east_1.cidr_blocks
#     for_each = local.allowed_cidr_blocks
#     #for_each = toset(local.limited_cidr_blocks) # Convert list to a set to ensure only the intended values are used
#     content {
#       description = "Allow SSH from AWS IPs"
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       cidr_blocks = [ingress.value]
#     }
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create Security Group - Web Traffic
# resource "aws_security_group" "vpc-web" {
#   name        = "vpc-web"
#   description = "Dev VPC Web"

#   dynamic "ingress" {
#     # for_each = data.aws_ip_ranges.us_east_1.cidr_blocks
#     for_each = local.allowed_cidr_blocks
#     # for_each = toset(local.limited_cidr_blocks)

#     content {
#       description = "Allow HTTP traffic from AWS IPs"
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       cidr_blocks = [ingress.value]
#     }
#   }

#   dynamic "ingress" {
#     for_each = data.aws_ip_ranges.us_east_1.cidr_blocks
#     content {
#       description = "Allow HTTPS traffic from AWS IPs"
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       cidr_blocks = [ingress.value]
#     }
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
