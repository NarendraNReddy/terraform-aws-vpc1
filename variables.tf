#Project variables
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

#VPC variables

variable "vpc_cidr"{
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type=bool 
    default = true 
}

#commcon tags
variable "common_tags" {
  type=map
}

#VPC 
variable "vpc_tags" {
    default = {}

}

#IGW

variable "igw_tags" {
    default = {}
  
}

#public subnet
variable "public_subnet_cidrs" {
    type=list
  validation {
    condition = length(var.public_subnet_cidrs) == 2
    error_message = "Please enter two valid subnets"
  }
}



variable "public_tags" {
    default = {}
  
}

# #private subnet

variable "private_subnet_cidrs" {
    type=list
  validation {
    condition = length(var.private_subnet_cidrs) == 2
    error_message = "Please enter two valid subnets"
  }
}



variable "private_tags" {
    default = {}
  
}


#database  subnet:

variable "database_subnet_cidrs" {
    type=list
  validation {
    condition = length(var.database_subnet_cidrs) == 2
    error_message = "Please enter two valid subnets"
  }
}

variable "database_tags" {
    default = {}
  
}


variable "database_subnet_group_tags"{
    default = {}
}


variable "nat_gateway_tags" {
  default = {}
}


variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
  default = {}
}

variable "database_route_table_tags" {
  default = {}
}


#PEERING
variable "is_peering_required" {
  type=bool 
  
}

variable "acceptor_vpc_id" {
  type=string 
  default = ""
}


variable "vpc_peering_tags" {
  type=map 
  default = {}
}