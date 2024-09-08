provider "aws" {
  region = "ap-northeast-1"
}

module "alb" {
  source = "../../modules/networking/alb"

  cluster_name = "webservers-${var.environment}"
  alb_name = "hello-world-${var.environment}"
  subnet_ids = data.aws_subnets.default.ids
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