resource "aws_default_security_group" "kunle-default-sg" {
  vpc_id = var.vpc_id

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
    Name: "${var.env_prefix}-default-sg"
  }
}

/*resource "aws_key_pair" "kunle-ssh-key"{
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_route_table_association" "kunle-rtb-subnet" {
  subnet_id = aws_subnet.kunle-sub.id
  route_table_id = aws_default_route_table.kunle-default-rtb.id
}

data "aws_ami" "lastest-amazon-linux-image"{
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["*****"]

  }
}*/

resource "aws_instance" "kunle-server" {
 ami = "ami-01c265752adadcdf8"
 instance_type = "t2.micro"
 availability_zone = var.avail_zone
 subnet_id = var.subnet_id
 vpc_security_group_ids = [aws_default_security_group.kunle-default-sg.id]
 associate_public_ip_address = true
 key_name = "kunle-TWN-key-pair"

 user_data = file("${path.module}/entry-script.sh")

 user_data_replace_on_change = true

 tags = {
  Name = "${var.env_prefix}-server"
 }
}