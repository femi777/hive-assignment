resource "aws_lb" "this" {

  name               = "${var.project_name}-alb"
  internal           = var.alb_internal_external
  load_balancer_type = var.alb_load_balancer_type
  security_groups    = [aws_security_group.alb_sg.id,aws_security_group.ecs_sg.id]
  subnets = [
    for k, s in aws_subnet.this :
    s.id if local.flattened_subnets[k].vpc == "vpc_0"
  ]
}

resource "aws_lb_target_group" "this" {
  
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
