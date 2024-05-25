#resource_name=${var.project_name}-${var.environment}"
locals {
  resource_name="${var.project_name}-${var.environment}"
  azs_names=slice(data.aws_availability_zones.availble.names,0,2)
}