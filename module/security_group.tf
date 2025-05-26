resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.this.id


  dynamic "ingress" {
    for_each = var.alb_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.alb_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(local.tags, {
    
    Name = "alb-sg"
  }
  )
}

resource "aws_security_group" "ecs_sg" {
  
  name        = "ecs-sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.ecs_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol

      # Use security_groups or cidr_blocks based on input
      security_groups = [aws_security_group.alb_sg.id]
      cidr_blocks     = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.ecs_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
 tags = merge(local.tags, {
    
    Name = "ecs-sg"
  }
  )
 
}
