resource "aws_lb" "lb" {
  name               = "nebula-elb"
  subnets            = module.vpc.public_subnets
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_security_group" "lb_sg" {
  name   = "Load balancer security group"
  vpc_id = module.vpc.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}


resource "aws_lb_target_group" "api" {
  name     = "api-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  target_type = "ip"
  
  health_check {
    path = "/api/health-check"
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}