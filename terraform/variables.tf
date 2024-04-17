variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.10.0/24"
}

variable "availability_zone" {
  default = "ap-south-1a"
}

variable "env-prefix" {
  default = "dev"
}

variable "image-name" {
  default = "al2023-ami-*-x86_64"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "jenkins"
}

variable "my_ip" {}
variable "jenkins_ip" {}
