resource "aws_instance" "my-ec2-vm" {
  for_each = { for idx, instance in var.ec2_instance_type : idx => instance }

  ami           = data.aws_ami.amzlinux.id
  instance_type = each.value.type
  key_name      = aws_key_pair.my-key.key_name

  # Assign subnet ID dynamically
  subnet_id = lookup(
    { for k, v in aws_subnet.subnets : v.tags.Name => v.id if v.tags.Name != null },
    "${each.value.vpc}-subnet-${each.value.subnet}",
    null
  )
  # Assign private IP dynamically (or let AWS assign)
  private_ip = each.value.private_ip != "" ? each.value.private_ip : null

  # Fix security group lookup
  vpc_security_group_ids = compact([
    lookup(aws_security_group.vpc_ssh, each.value.vpc, null) != null ? aws_security_group.vpc_ssh[each.value.vpc].id : "",
    lookup(aws_security_group.vpc_web, each.value.vpc, null) != null ? aws_security_group.vpc_web[each.value.vpc].id : ""
  ])

  user_data = each.value.role == "master" ? file("master-user-data.sh.tpl") : file("worker-user-data.sh")

  tags = {
    Name = "${each.value.role}-${each.key}"
    VPC  = each.value.vpc
  }
}


resource "aws_vpc" "dev" {
  for_each = var.vpcs

  cidr_block           = each.value.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "subnets" {
  for_each = merge([
    for vpc_name, vpc_config in var.vpcs : {
      for subnet_cidr in vpc_config.subnets : "${vpc_name}-${subnet_cidr}" => {
        vpc_name   = vpc_name
        cidr_block = subnet_cidr
        type       = index(vpc_config.subnets, subnet_cidr) == 0 ? "public" : "private"
      }
    }
  ]...)

  vpc_id                  = aws_vpc.dev[each.value.vpc_name].id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = index(var.vpcs[each.value.vpc_name].subnets, each.value.cidr_block) == 0

  tags = {
    Name = "${each.value.vpc_name}-subnet-${each.value.cidr_block}"
    Type = each.value.type
  }
}
resource "aws_internet_gateway" "igw" {
  for_each = var.vpcs

  vpc_id = aws_vpc.dev[each.key].id

  tags = {
    Name = "${each.key}-igw"
  }
}

resource "aws_route_table" "publicrt" {
  for_each = var.vpcs

  vpc_id = aws_vpc.dev[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.key].id
  }

  tags = {
    Name = "${each.key}-public-rt"
  }
}

resource "aws_route_table" "privatert" {
  for_each = var.vpcs

  vpc_id = aws_vpc.dev[each.key].id

  tags = {
    Name = "${each.key}-private-rt"
  }
}

resource "aws_route_table" "datart" {
  for_each = var.vpcs

  vpc_id = aws_vpc.dev[each.key].id

  tags = {
    Name = "${each.key}-data-rt"
  }
}

# resource "aws_route_table_association" "public_association" {
#   for_each = { for k, v in var.vpcs : k => v.subnets }

#   subnet_id = try(aws_subnet.subnets[each.key].id, null)
#   route_table_id = aws_route_table.publicrt[each.key].id
#   gateway_id     = aws_internet_gateway.igw[each.key].id  # Ensure IGW exists
# }

resource "aws_route_table_association" "public_association" {
  for_each = { for k, v in aws_subnet.subnets : k => v if can(regex("public", k)) }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.publicrt[split("-", each.key)[0]].id
  gateway_id     = aws_internet_gateway.igw[each.key].id  # Ensure IGW exists
}

# resource "aws_route_table_association" "private_association" {
#   for_each = { for k, v in var.vpcs : k => v.subnets }

#   subnet_id      = aws_subnet.subnets[each.key].id
#   route_table_id = aws_route_table.privatert[each.key].id
# }

resource "aws_route_table_association" "private_association" {
  for_each = { for k, v in aws_subnet.subnets : k => v if can(regex("private", k)) }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.privatert[split("-", each.key)[0]].id
}

# resource "aws_route_table_association" "data_association" {
#   for_each = { for k, v in var.vpcs : k => v.subnets }

#   subnet_id      = aws_subnet.subnets[each.key].id
#   route_table_id = aws_route_table.datart[each.key].id
# }

resource "aws_route_table_association" "data_association" {
  for_each = { for k, v in aws_subnet.subnets : k => v if can(regex("data", k)) }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.datart[split("-", each.key)[0]].id
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
