# Terraform template for AWS
# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "aws-security" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "${var.environment}"
    Repository = "aws-security"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "aws-security" {
  vpc_id = "${aws_vpc.aws-security.id}"
  tags {
    Name = "${var.environment}"
    Repository = "aws-security"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.aws-security.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.aws-security.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "aws-security" {
  vpc_id                  = "${aws_vpc.aws-security.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.environment}"
    Repository = "aws-security"
  }
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "${var.environment}-elb-sg"
  description = "Security group to access ELB from Internet"
  vpc_id      = "${aws_vpc.aws-security.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}"
    Repository = "aws-security"
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "aws-security" {
  name        = "${var.environment}-instance-sg"
  description = "Security group to access instance directly"
  vpc_id      = "${aws_vpc.aws-security.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["80.194.88.118/32"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.environment}"
    Repository = "aws-security"
  }
}

resource "aws_elb" "web" {
  name = "${var.environment}-elb"

  subnets         = ["${aws_subnet.aws-security.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags {
    Name = "${var.environment}"
    Repository = "aws-security"
  }
}

resource "aws_route53_record" "web" {
  zone_id = "${var.zone_id}"
  name    = "www.${var.environment}.${var.domain}"
  type    = "A"

  alias {
    name    = "${aws_elb.web.dns_name}"
    zone_id = "${aws_elb.web.zone_id}"

    evaluate_target_health = true
  }
}

resource "aws_instance" "web" {
  instance_type = "m1.small"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair
  key_name = "${var.aws_key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.aws-security.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.aws-security.id}"

  user_data = "${file("user-data-web")}"

  tags {
    Name = "${var.environment}"
    Repository = "aws-security"
  }
}
