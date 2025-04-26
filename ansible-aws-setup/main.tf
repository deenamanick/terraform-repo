# Create EC2 Instances in the Public Subnet
resource "aws_instance" "my-ec2-vm" {
  ami = data.aws_ami.amzlinux.id
  #ami                    = "ami-0b0ea68c435eb488d"
  instance_type          = each.value.type
  key_name               = aws_key_pair.my-key.key_name
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  subnet_id              = aws_subnet.public-subnet.id # Deploy in the public subnet
  private_ip             = each.value.private_ip       # Assign specific private IP
  user_data              = each.value.role == "master" ? file("master-user-data.sh.tpl") : file("worker-user-data.sh")

  tags = {
    Name = "${each.value.role}-${each.key}"
  }

  for_each = { for idx, instance in var.ec2_instance_type : idx => instance }
}

locals {
  master_ip  = aws_instance.my-ec2-vm["0"].private_ip
  worker_ips = [for idx, instance in aws_instance.my-ec2-vm : instance.private_ip if idx != "0"]
}


# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

# Create Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Automatically assign public IPs
  availability_zone       = "us-east-1a"
  tags = {
    Name = "PublicSubnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "PrivateSubnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Create Public Route Table
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

# Create Private Route Table
resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "PrivateRouteTable"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.publicrt.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.privatert.id
}

############ Creating Key pair for EC2 ############
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my-key" {
  key_name   = "testkey"
  public_key = tls_private_key.example.public_key_openssh
}
