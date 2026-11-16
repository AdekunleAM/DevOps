resource "aws_subnet" "kunle-sub"{
 vpc_id = var.vpc_id
 cidr_block = var.sub_cidr_block
 availability_zone = var.avail_zone
 tags = {
    Name = "kunle-TWN-subnet"
 }
}

resource "aws_default_route_table" "kunle-default-rtb" {
  default_route_table_id = var.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kunle-igw.id
  }
  tags = {
    Name = "kunle-TWN-rtb"
  }
}

resource "aws_internet_gateway" "kunle-igw"{
  vpc_id = var.vpc_id
  tags = {
    Name: "kunle-TWN-igw"
  }
}