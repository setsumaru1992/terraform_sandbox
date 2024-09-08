provider "aws" {
  region = "ap-northeast-1"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name = "webservers-stage"
  instance_type = "t2.micro"
  autoscale_min_size = 2
  autoscale_max_size = 3
}