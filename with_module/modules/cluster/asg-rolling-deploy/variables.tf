variable "cluster_name" {
  description = "hogehoge"
  type = string
}

variable "instance_type" {
  description = "hogehoge"
  type = string
  default = "t2.micro"
}

variable "ami" {
  description = "hogehoge"
  type = string
  default = "ami-0091f05e4b8ee6709"
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

variable "server_port" {
  description = "The port the server will user for HTTP requests"
  type = number
  default = 8080
}

variable "subnet_ids" {
  description = "hogehoge"
  type = list(string)
}

variable "target_group_arns" {
  description = "hogehoge"
  type = list(string)
  default = []
}

variable "health_check_type" {
  description = "hogehoge"
  type = string
}

variable "user_data" {
  description = "hogehoge"
  type = string
  default = null
}
