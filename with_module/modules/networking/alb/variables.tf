variable "cluster_name" {
  description = "hogehoge"
  type = string
}

variable "alb_name" {
  description = "hogehoge"
  type = string
  default = "terraform-asg-example"
}

variable "subnet_ids" {
  description = "hogehoge"
  type = list(string)
}