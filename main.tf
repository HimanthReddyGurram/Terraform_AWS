# commented code in this file can also be uncommented and used but the other code relating to that must be commented.
# some extra parts of the code are omitted.

# creating a VPC
resource "aws_vpc" "him_vpc" {
  cidr_block = "10.0.0.0/16"
  #   enable_dns_hostnames = true
  #   enable_dns_support   = true

  tags = {
    Name = "development"
  }
}


# creating a Internet gateway
resource "aws_internet_gateway" "him_gateway" {
  vpc_id = aws_vpc.him_vpc.id

  tags = {
    Name = "development-InternetGateway"
  }
}


# # creating a route table and assingning routes through route method

# resource "aws_route_table" "him_public_rt" {
#   vpc_id = aws_vpc.him_vpc.id

#   tags = {
#     Name = "development-public-rt"
#   }
# }
# resource "aws_route" "him_route" {
#   route_table_id         = aws_route_table.him_public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.him_gateway.id
# }


# # creating a route table and assingning routes through inline method
resource "aws_route_table" "him_public_rt" {
  vpc_id = aws_vpc.him_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.him_gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.him_gateway.id
  }
  tags = {
    Name = "development-public-rt"
  }
}


# creating a Subnet
resource "aws_subnet" "him_public_subnet" {
  vpc_id            = aws_vpc.him_vpc.id
  # cidr_block        = "10.0.1.0/24"
  cidr_block        = var.subnet_params # this will ask for an input if it isnt provided
  availability_zone = "ap-southeast-1a"
  #   map_public_ip_on_launch = true

  tags = {
    Name = "development-public"
  }
}


# creating a Route table association
resource "aws_route_table_association" "him_route_table" {
  subnet_id      = aws_subnet.him_public_subnet.id
  route_table_id = aws_route_table.him_public_rt.id
}


# creating a Security group
resource "aws_security_group" "him_secGroup" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.him_vpc.id

  ingress {
    description = "All web types" # like http, https, ssh
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# adding a network interface
resource "aws_network_interface" "him_net_int" {
  subnet_id       = aws_subnet.him_public_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.him_secGroup.id]
}


# assigning an elastic IP to the network interface
resource "aws_eip" "him_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.him_net_int.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.him_gateway] # this makes sure that even if this resource is declared above IG it will ask for it to be declared expplicitly
}


# creating an ubuntu server
resource "aws_instance" "him_instance" {
  ami = data.aws_ami.him_ami.id
  # or we could provide the raw ami id without 'datasource.tf' file
  instance_type     = "t2.micro"
  availability_zone = "ap-southeast-1a"
  key_name="iam_user-keyPair"

  network_interface{
    device_index=0
    network_interface_id=aws_network_interface.him_net_int.id
  }

	user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y apache2
                sudo systemctl start apache2
                sudo systemctl enable apache2
                echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "development-instance"
  }

}

# outputs are shown in the terminal and are used instead of terraform state show <resource> command.
output "server_public_ip"{
value =aws_instance.him_instance.instance_type
}

output "egress_sg"{
value=aws_security_group.him_secGroup.egress
}

# declaring a variable where we can reference it in the future.
variable subnet_params {
  type        = string
  default     = "10.0.1.0/24"
  description = "subnet cidr blocks and descriptions"
}