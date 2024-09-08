provider "aws" {
  region = "ap-northeast-1"
}

module "asg" {
  source = "../../modules/cluster/asg-rolling-deploy"

  cluster_name = "webservers-${var.environment}"
  instance_type = "t2.micro"
  ami = data.aws_ami.amazon-linux.id
  autoscale_min_size = 1
  autoscale_max_size = 1

  subnet_ids = data.aws_subnets.default.ids

  health_check_type = "ELB"
}

variable "environment" {
  type = string
  default = "example"
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

data "aws_ami" "amazon-linux" {
  most_recent = true #最新版を指定

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}