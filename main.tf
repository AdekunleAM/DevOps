provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "kunle-vpc" {
 cidr_block = var.vpc_cidr_block
 tags = {
   Name = "kunle-TWN-vpc"
 }
}

module "kunle-subnet"{
  source = "./modules/subnet"
  sub_cidr_block = var.sub_cidr_block
  avail_zone = var.avail_zone
  vpc_id = aws_vpc.kunle-vpc.id
  default_route_table_id = aws_vpc.kunle-vpc.default_route_table_id
}

module "kunle-webserver" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.kunle-vpc.id
  my_ip = var.my_ip
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  subnet_id = module.kunle-subnet.subnet.id
}
