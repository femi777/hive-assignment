locals {
  tags = {
      Environment = var.environment
  } 
  #vpc_map = { for i, cidr_block in var.cidr_blocks : "vpc_${i}" => cidr_block }
  flattened_subnets = merge([ for vpc_key, subnet_map in var.subnets : {
                      for subnet_key, cidr in subnet_map :
                      "${vpc_key}_${subnet_key}" => {
                        cidr = cidr
                        vpc  = vpc_key
                        name = subnet_key
                        az   = subnet_key == "public_a" ? "us-east-1a" : "us-east-1b"
                      }
    }

  ]...)
  
  container_definitions = [
    {
      name            = var.container_settings.name
      image           = var.container_image
      portMappings    = var.container_settings.portMappings
    }
  ]
}
#flattened_subnets = {
#   "vpc_0_public_a" = {
#     cidr = "10.0.1.0/24"
#     vpc  = "vpc_0"
#     name = "public_a"
#     az   = "us-east-1a"
#   },
#   "vpc_0_public_b" = {
#     cidr = "10.0.2.0/24"
#     vpc  = "vpc_0"
#     name = "public_b"
#     az   = "us-east-1b"
#   }
# }