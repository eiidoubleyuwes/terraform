#Create VPC
resource "aws-vpc" "newvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "newvpc"
  }
}
#Create Subnet
resource "aws-subnet" "newvpc-subnet" {
    vpc_id     = aws-vpc.newvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "newvpc-subnet"
  }
}
#Create Internet Gateway
resource "aws-internet-gateway" "newvpc-igw" {
    vpc_id = aws-vpc.newvpc.id

  tags = {
    Name = "newvpc-igw"
  }
}
#Create Route Table
resource "aws-route-table" "newvpc-rtb" {
    vpc_id = aws-vpc.newvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws-internet-gateway.newvpc-igw.id
  }

  tags = {
    Name = "newvpc-rtb"
  }
}
#Create Route Table Association with subnet
resource "aws-route-table-association" "newvpc-rtb-association" {
    subnet_id      = aws-subnet.newvpc-subnet.id
    route_table_id = aws-route-table.newvpc-rtb.id
}
#Create Security Group
resource "aws-security-group" "newvpc-sg" {
    vpc_id = aws-vpc.newvpc.id
    #Inbound rules(HTTP,HTTPS,SSH)
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "newvpc-sg"
    }
}
#Create EC2 Instance
resource "aws-instance" "newvpc-instance" {
    ami = "ami-0fc61db8544a617ed"
    instance_type = "t2.micro"
    subnet_id = aws-subnet.newvpc-subnet.id
    vpc_security_group_ids = [aws-security-group.newvpc-sg.id]
    tags = {
        Name = "newvpc-instance"
    }
}
#Create Elastic IP
resource "aws-eip" "newvpc-eip" {
    instance = aws-instance.newvpc-instance.id
    vpc = true
    tags = {
        Name = "newvpc-eip"
    }
}
#Attach Elastic IP to EC2 Instance
resource "aws-eip-association" "newvpc-eip-association" {
    instance_id = aws-instance.newvpc-instance.id
    allocation_id = aws-eip.newvpc-eip.id
}
