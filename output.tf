output "azs" {
  value = data.aws_availability_zones.availble.names
}

output "vpc_id"{
    value=aws_vpc.main.id
}

output "igw"{
    value=aws_internet_gateway.gw.id
}

# output "public_subnet" {
#   value=aws_subnet.public[0].id
# }



output "default_vpc_id1" {
  value = data.aws_vpc.default.id
}

output "default_vpc_route_table" {
  value=data.aws_route_table.main.id
}