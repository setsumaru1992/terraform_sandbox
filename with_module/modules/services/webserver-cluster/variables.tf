variable "cluster_name" {
  description = "hogehoge"
  type = string
}

variable "instance_type" {
  description = "hogehoge"
  type = string
  default = "t2.micro"
}

variable "autoscale_min_size" {
  description = "hogehoge"
  type = number
  default = 2
}

variable "autoscale_max_size" {
  description = "hogehoge"
  type = number
  default = 3
}
