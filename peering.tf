resource "aws_vpc_peering_connection" "peering" {
  count=var.is_peering_required ? 1:0
  vpc_id      = aws_vpc.main.id #Requestor
  #peer_vpc_id = aws_vpc.bar.id #Acceptor
  peer_vpc_id = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id:var.acceptor_vpc_id
  #auto_accept = true
  auto_accept = var.acceptor_vpc_id == ""? true:false
  tags=merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
      Name="${local.resource_name}" #expense-dev
    }
  )
}


#Route table assocation.Count is use ful to control when resource
resource "aws_route" "public_route_vpc" {
  count=var.is_peering_required && var.acceptor_vpc_id == "" ? 1:0
  route_table_id            = aws_route_table.public.id 
  destination_cidr_block    = data.aws_vpc.default.cidr_block #default VPC IP address
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "private_route_vpc" {
  count=var.is_peering_required && var.acceptor_vpc_id == "" ? 1:0
  route_table_id            = aws_route_table.private.id 
  destination_cidr_block    = data.aws_vpc.default.cidr_block #default VPC IP address
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "database_route_vpc" {
  count=var.is_peering_required && var.acceptor_vpc_id == "" ? 1:0
  route_table_id            = aws_route_table.database.id 
  destination_cidr_block    = data.aws_vpc.default.cidr_block #default VPC IP address
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "default_peering" {
  count=var.is_peering_required && var.acceptor_vpc_id == "" ? 1:0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.vpc_cidr #default VPC IP address
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}
