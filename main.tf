provider "aws" {
  region = "us-east-2"
}

#creating vpc

variable "sub_cidr_block" {
 description = "subnet cidr block"
}

variable "vpc_cidr_block"{
 description = "vpc cidr block"
}

resource "aws_vpc" "kunlevpc" {
 cidr_block = var.vpc_cidr_block
 instance_tenancy = "default"
 tags = {
   Name = "kunle"
 }
}

resource "aws_subnet" "kunle_sub"{
 vpc_id = aws_vpc.kunlevpc.id
 cidr_block = var.sub_cidr_block
 tags = {
    Name = "kunle_subnet"
 }
}

