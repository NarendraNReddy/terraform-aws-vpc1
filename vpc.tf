resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags =merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name=local.resource_name
    }
  )
}

#IGW create and attach to main VPC

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
        Name=local.resource_name
    }
  )
}

#SUBNET:
#public
resource "aws_subnet" "public" { #public[0],public[1]
  count=length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  #cidr_block = "10.0.1.0/24"
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = "${local.azs_names[count.index]}"
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_tags,
    {
        Name="${local.resource_name}-public-${local.azs_names[count.index]}" #expense-us-east-1a 
    }
  )
}

#private
resource "aws_subnet" "private" {
  count=length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  #cidr_block = "10.0.1.0/24"
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = "${local.azs_names[count.index]}"
  

  tags = merge(
    var.common_tags,
    var.private_tags,
    {
        Name="${local.resource_name}-private-${local.azs_names[count.index]}" #expense-us-east-1a 
    }
  )
}



#public
resource "aws_subnet" "database" {
  count=length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  #cidr_block = "10.0.1.0/24"
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = "${local.azs_names[count.index]}"
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.database_tags,
    {
        Name="${local.resource_name}-database-${local.azs_names[count.index]}" #expense-us-east-1a 
    }
  )
}


#EIP
resource "aws_eip" "expense" {
  domain   = "vpc"
}

#NAT gateway:

resource "aws_nat_gateway" "nat_public" {
  allocation_id = aws_eip.expense.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
           Name="${local.resource_name}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw] #explicit dependency NAT depends on internet
}


#Route table terraform
#public route tables 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

 
  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
        Name="${local.resource_name}-public"
    }
  )
}

#private route tables
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

 
  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
        Name="${local.resource_name}-private"
    }
  )
}

#database route tables
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

 
  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
        Name="${local.resource_name}-database"
    }
  )
}

#Routes additions 
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id

}

resource "aws_route" "private_route_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_public.id

}


resource "aws_route" "database_route_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_public.id

}

#Route table assocation
resource "aws_route_table_association" "public" {
   count=length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
   count=length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "database" {
   count=length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}


