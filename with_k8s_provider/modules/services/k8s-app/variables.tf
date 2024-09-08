variable "name" {
  description = "hoge"
  type = string
}

variable "image" {
  description = "hoge"
  type = string
}

variable "container_port" {
  description = "hoge"
  type = number
}

variable "replicas" {
  description = "hoge"
  type = number
}

variable "environment_variables" {
  description = "hoge"
  type = map(string)
  default = {}
}