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