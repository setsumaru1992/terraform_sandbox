provider "aws" {
  region = "ap-northeast-1"
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name = "webservers-${var.environment}"
  instance_type = "t2.micro"
  ami = "ami-0091f05e4b8ee6709"
  autoscale_min_size = 2
  autoscale_max_size = 3

  subnet_ids = data.aws_subnets.default.ids
  target_group_arns = [aws_lb_target_group.asg.arn]

  server_port = var.server_port

  health_check_type = "ELB"
  user_data = templatefile("${path.module}/user_data.sh", {
    server_port = var.server_port
  })
}

module "alb" {
  source = "../../networking/alb"

  cluster_name = "webservers-${var.environment}"
  alb_name = "hello-world-${var.environment}"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

