variable "environment" {
  description = "hogehoge"
  type = string
}

variable "server_port" {
  description = "The port the server will user for HTTP requests"
  type = number
  default = 8080
}
