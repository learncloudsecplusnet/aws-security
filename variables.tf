variable "aws_key_name" {
  description = "ssh key pair name"
  default = "learncloudsecplus-training"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

variable "environment" {}

# Ubuntu Precise 12.04 LTS (x64)
# 18.04
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-b1cf19c6"
    #eu-west-1 = "ami-08d658f84a6d84a80"
    us-east-1 = "ami-de7ab6b6"
    us-west-1 = "ami-3f75767a"
    us-west-2 = "ami-21f78e11"
  }
}

variable "zone_id" {
  description = "Route53 Zone ID"
  default     = "Z28NL6U3EBRK22" # Zone ID for learncloudsecplus.net
}

variable "domain" {
  description = "root domain"
  default     = "learncloudsecplus.net"
}

variable "ssh_ip"{
  description = "SSH IP allow"
  default = "212.250.100.150/32"
}
