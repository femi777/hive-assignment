 
variable "alb_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

 variable "alb_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
variable "cidr_blocks" {
    type = string
    default = "10.0.0.0/16"
}

variable "ecs_ingress_rules" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    security_groups  = list(string)
    cidr_blocks      = list(string)
  }))
  default = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = []             # override with SG ID
      cidr_blocks     = ["0.0.0.0/0"]             # optional fallback
    }
  ]
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}

variable "ecs_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

#alb.tf
variable "alb_load_balancer_type" {
  type = string
  default = "application"
}

variable "alb_internal_external" {
  type = bool
  default = false
}

#ecr.tf
variable "registry_name" {
  type = string
  default = "hive-registry"
}

#ecs.tf
variable "family" {
  type = string
  default = "nginx"
}

variable "network_mode" {
  type = string 
  default = "awsvpc"
}

variable "container_image" {
  type = string
  default = "123456789012.dkr.ecr.us-east-1.amazonaws.com/nginx:latest"
}

variable "container_settings" {
  description = "Base settings for the ECS container definition"
  type = object({
    name          = string
    portMappings  = list(object({
      containerPort = number
      protocol      = string
    }))
  })

  default = {
    name = "nginx"
    portMappings = [
      {
        containerPort = 80
        protocol      = "tcp"
      }
    ]
  }
}


variable "project_name" {
  type = string
  default = "hive"
}

 variable "region" {
  default = "us-east-1"
}

variable "subnets" {
  description = "Map of VPC to their subnets"
  type = map(map(string)) # map of map of string

  default = {
    vpc_0 = {
      public_a = "10.0.1.0/24"
      public_b = "10.0.2.0/24"
    }
}
}

