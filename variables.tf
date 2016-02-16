variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "platform" {
  default = "ubuntu"
  description = "The OS Platform"
}

variable "user" {
 default = "ec2-user"
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "
  default = {
    us-east-1 = "ami-e3106686"
    us-west-2 = "ami-9ff7e8af"
  }
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
  description = "Path to the private key specified by key_name."
}

variable "servers" {
  default = "3"
  description = "The number of Consul servers to launch."
}

variable "instance_type" {
  default = "t2.micro"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagServerName" {
  default = "consul-server"
  description = "Name tag for the servers"
}
