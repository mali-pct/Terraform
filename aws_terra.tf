#Creating the AWS infrastructure using terraform
#Create an EC2 instance
resource "aws_instance" "terraform-instance" {
  ami = "ami-06b09bfacae1453cb"
  instance_type = "t2.micro"
  tags = {
    Name = "terraformEC2"
  }
  
}

#create VPC
#terrform aws create vpc

resource "aws_vpc" "vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = "terraformVPC"
  }
}
  

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id


  tags = {
    Name = "terraformIGW"
  }
}
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraformpublicsubnet"
  }
}
resource "aws_route_table" "public-route-table" {
  vpc_id     = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "terraformpublicRT"
  }

}
resource "aws_route_table_association" "public-subnet-route-table-association" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id

}
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "terraformprivatesubnet"
  }
}

resource "aws_route_table" "private-route-table" {
   vpc_id     = aws_vpc.vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "terraformpublicRT"
  }
}
resource "aws_route_table_association" "private-subnet-route-table-assosiation" {
   subnet_id = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

