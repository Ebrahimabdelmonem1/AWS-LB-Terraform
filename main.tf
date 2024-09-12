#create the vpc
resource "aws_vpc" "my_VPC" {
  cidr_block           = "192.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MY_VPC"
  }
}


#create public subnet 1
resource "aws_subnet" "public_sub1" {
  vpc_id            = aws_vpc.my_VPC.id
  cidr_block        = "192.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public1"
  }
}



#create public subnet 2
resource "aws_subnet" "public_sub2" {
  vpc_id            = aws_vpc.my_VPC.id
  cidr_block        = "192.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public2"
  }
}


#create private subnet 1
resource "aws_subnet" "private_sub1" {
  vpc_id            = aws_vpc.my_VPC.id
  cidr_block        = "192.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private1"
  }
}

#create private subnet 1

resource "aws_subnet" "private_sub2" {
  vpc_id            = aws_vpc.my_VPC.id
  cidr_block        = "192.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private2"
  }

}


# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_VPC.id

  tags = {
    Name = "IGW1"
  }
}


# Create a public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
}

#create private aws_route_table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_VPC.id

  route {
    cidr_block = "192.0.0.0/16"
    gateway_id = "local"
  }



  tags = {
    Name = "Private_Route_Table"
  }
}



# Associate the route table with the public subnet
resource "aws_route_table_association" "public1_rt_association" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.public_route_table.id
}


# Associate the route table with the private subnet
resource "aws_route_table_association" "private1_rt_association" {
  subnet_id      = aws_subnet.private_sub1.id
  route_table_id = aws_route_table.private_route_table.id
}



# Associate the route table with the public subnet
resource "aws_route_table_association" "public2_rt_association" {
  subnet_id      = aws_subnet.public_sub2.id
  route_table_id = aws_route_table.public_route_table.id
}


# Associate the route table with the private subnet
resource "aws_route_table_association" "private2_rt_association" {
  subnet_id      = aws_subnet.private_sub2.id
  route_table_id = aws_route_table.private_route_table.id
}