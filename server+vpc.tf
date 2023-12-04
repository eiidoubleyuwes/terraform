
#Creates an amazon linux machine with the name tag "AmazonLinax"
resource "aws_instance" "terraformserver" {
  ami           = "ami-0fa1ca9559f1892ec"
  instance_type = "t2.micro"
  tags = {
    Name = "AmazonLinux"
  }
}
#Creating an Amzon VPC with 69k Ip adresses
resource "aws_vpc" "terminalvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Terminal vpc"
  }  
}
#Creating a subnet inside the created VPC
resource "aws_subnet" "Terminal" {
  vpc_id = aws_vpc.terminalvpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    "Name" = "Public subnet"
  }
}
