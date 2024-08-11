provider "aws" {
  region = "ap-northeast-1"
}

# data aws_ssm_parameter amzn2_ami {
#   name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
# }

resource "aws_instance" "example" {
#   ami           = data.aws_ssm_parameter.amzn2_ami.value
  ami = "ami-0f310fced6141e627"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}