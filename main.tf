provider "aws" {
  region = "us-east-2"
}

variable "sub_cidr_block" {}
variable "vpc_cidr_block"{}
variable "my_ip" {}
variable "env_prefix" {}
variable "avail_zone" {}

resource "aws_vpc" "kunle-vpc" {
 cidr_block = var.vpc_cidr_block
 tags = {
   Name = "kunle-TWN-vpc"
 }
}

resource "aws_subnet" "kunle-sub"{
 vpc_id = aws_vpc.kunle-vpc.id
 cidr_block = var.sub_cidr_block
 tags = {
    Name = "kunle-TWN-subnet"
 }
}

resource "aws_route_table" "kunle-rtb" {
  vpc_id = aws_vpc.kunle-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kunle-igw.id
  }
  tags = {
    Name = "kunle-TWN-rtb"
  }
}

resource "aws_internet_gateway" "kunle-igw"{
  vpc_id = aws_vpc.kunle-vpc.id
  tags = {
    Name: "kunle-TWN-igw"
  }
}

resource "aws_route_table_association" "kunle-rtb-subnet" {
  subnet_id = aws_subnet.kunle-sub.id
  route_table_id = aws_route_table.kunle-rtb.id
}

resource "aws_default_security_group" "kunle-default-sg" {
  vpc_id = aws_vpc.kunle-vpc.id

  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = [var.my_ip]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      prefix_list_ids = []
  }
  tags = {
    Name: "kunle-TWN-default-sg"
  }
}

/*resource "aws_key_pair" "kunle-ssh-key"{
  key_name = "server-key"
  public_key =
}*/

resource "aws_instance" "kunle-server" {
 ami = "ami-01c265752adadcdf8"
 instance_type = "t2.micro"
 subnet_id = aws_subnet.kunle-sub.id
 vpc_security_group_ids = [aws_default_security_group.kunle-default-sg.id]
 associate_public_ip_address = true
 key_name = "kunle-TWN-key-pair"

 user_data = file("entry-script.sh")

 user_data_replace_on_change = true

 tags = {
  Name = "${var.env_prefix}-server"
 }
}
