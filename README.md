# 🚀 Hive Infrastructure Deployment (ECS, ALB, ECR on AWS)

This Terraform project provisions a complete container-based infrastructure on AWS using:

- **Amazon ECS (Fargate)**
- **Elastic Load Balancer (ALB)**
- **Elastic Container Registry (ECR)**
- **Auto-generated VPC, Subnets, Route Tables, and Security Groups**

---

## 📁 Module Overview

### 🧩 `alb.tf`
- Creates an **Application Load Balancer (ALB)** in public subnets for the main VPC.
- Connects ALB to security groups and a target group.
- Sets up a listener on port 80 forwarding to the ECS service.

### 🐳 `ecr.tf`
- Creates an ECR repository (`hive-registry`).
- Creates an ECS Cluster and Fargate Task Definition running **NGINX**.
- Deploys an ECS Service behind the ALB.

### 🌐 `vpc.tf`
- Provisions a **VPC** with CIDR `10.0.0.0/16`.
- Creates two **public subnets**: `10.0.1.0/24` and `10.0.2.0/24`.
- Adds an **Internet Gateway** and public **Route Table**.
- Associates subnets with the route table.

### 🔐 `security_group.tf`
- **ALB Security Group**: Allows HTTP (port 80) from the internet.
- **ECS Security Group**: Allows inbound from ALB security group only.
- Both groups have full outbound access.

---

## 📦 Input Variables

| Name                | Type                | Default               | Description                          |
|---------------------|---------------------|------------------------|--------------------------------------|
| `region`            | `string`            | `"us-east-1"`          | AWS region                           |
| `project_name`      | `string`            | `"hive"`               | Prefix for resource names            |
| `cidr_blocks`       | `string`            | `"10.0.0.0/16"`        | CIDR block for the VPC               |
| `subnets`           | `map(map(string))`  | See example below      | Map of subnets per VPC               |
| `environment`       | `string`            | `"dev"`                | Tag to mark the environment          |
| `alb_ingress_rules` | `list(object)`      | Port 80 from `0.0.0.0/0` | Ingress rules for ALB security group |
| `alb_egress_rules`  | `list(object)`      | Allow all              | Egress rules for ALB                 |
| `ecs_ingress_rules` | `list(object)`      | Port 80 from ALB SG    | Ingress for ECS tasks                |
| `ecs_egress_rules`  | `list(object)`      | Allow all              | Egress for ECS tasks                 |

### Usage:
```hcl
module "app" {
  source = "./example"
  project_name = "hive"
  registry_name = "hive-registry
  family = "nginx"
  network_mode = "awsvpc"
  container_image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/nginx:latest"
  alb_load_balancer_type = "application"
  alb_internal_external = "false"
  container_settings = {
    name = "nginx"
    portMappings = [
      {
        containerPort = 80
        protocol      = "tcp"
      }
    ]
  }
  subnets = {
      vpc_0 = {
      public_a = "10.0.1.0/24"
      public_b = "10.0.2.0/24"
    }
  }
  alb_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  alb_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
 cidr_blocks = "10.0.0.0/16"
 ecs_ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = []            
      cidr_blocks     = ["0.0.0.0/0"]
    }
 ]
 ecs_egress_rules = [
   {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
 ]
}