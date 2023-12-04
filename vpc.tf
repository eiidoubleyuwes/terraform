#Creating an Amazon VPC with 69k Ip adresses
resource "aws_vpc" "labvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Terminal vpc"
  }  
}
#Creating a subnet inside the created VPC
resource "aws_subnet" "publinyo" {
  vpc_id = aws_vpc.terminalvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    "Name" = "Public subnet"
  }
}
#Creating a subnet inside the created VPC
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.terminalvpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    "Name" = "Private subnet"
  }
}