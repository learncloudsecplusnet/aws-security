variable "aws_key_name" {
  description = "ssh key pair name"
  default = "celidor-training"
}

variable "shared_credentials_file" {
  description = "path to AWS credentials"
  default     = "~\\.aws\\credentials"
}

variable "aws_credentials_profile" {
  description = "profile for AWS credentials"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-b1cf19c6"
    us-east-1 = "ami-de7ab6b6"
    us-west-1 = "ami-3f75767a"
    us-west-2 = "ami-21f78e11"
  }
}
