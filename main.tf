provider "aws" {
  region = "ap-northeast-1"
}

# resource "aws_instance" "example" {
#   ami = "ami-0091f05e4b8ee6709"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.instance.id]
#
#   user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello, World" > index.html
#               echo "current path: $(pwd)"
#               python3 -m http.server ${var.server_port_of_root_tf} --directory . &
#               EOF
#
#   user_data_replace_on_change = true
#
#   tags = {
#     Name = "terraform-example"
#   }
# }

# output "public_ip" {
#   value = aws_instance.example.public_ip
#   description = "The public IP address of the web server"
# }

resource "aws_launch_configuration" "example" {
  image_id = "ami-0091f05e4b8ee6709"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = templatefile("user_data.sh", {
    server_port_of_root_tf = var.server_port_of_root_tf
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  max_size = 3
  min_size = 2

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port_of_root_tf
    to_port = var.server_port_of_root_tf
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   # デバッグ時ssh用、2222を22に変えてブラウザでターミナル開く
#   ingress {
#     from_port = 2222
#     to_port = 2222
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
}

variable "server_port_of_root_tf" {
  description = "The port the server will user for HTTP requests"
  type = number
  default = 8080
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

resource "aws_lb" "example" {
  name = "terraform-asg-example"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-example"
  port = var.server_port_of_root_tf
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
  listener_arn = aws_lb_listener.http.arn
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

output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}