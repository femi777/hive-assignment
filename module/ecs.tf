resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  network_mode             = var.network_mode
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode(
    local.container_definitions
  )
}

resource "aws_ecs_service" "this" {
  
  name            = "${var.container_image}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets = [
    for k, s in aws_subnet.this :
    s.id if local.flattened_subnets[k].vpc == "vpc_0"
  ]
    security_groups = [aws_security_group.alb_sg.id,aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.container_image
    container_port   = var.container_settings.portMappings[0].containerPort
  }
}
