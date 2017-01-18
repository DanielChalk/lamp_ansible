variable "key_name" {
  type = "string"
  description = "aws keyname for the hosts"
}

provider "aws" {
  region = "eu-west-1"
}

#setup a virtual private network
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# allow our machines access to the internet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "Public"
  }
}

# lets set some rules to ensure we only allow access we want

resource "aws_security_group" "web" {
  name        = "web_security_group"
  description = "http/https"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # any
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# make some instance

resource "aws_instance" "web" {
  ami                    = "ami-d881f2ab"
  instance_type          = "t2.medium"
  count                  = 2
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name               = "${var.key_name}"

  # should be private but we will be public for now.
  subnet_id = "${aws_subnet.default.id}"
}

# we would normally have a bastion here also but for time we have left it out.

# balancers

resource "aws_elb" "balancer" {
  name            = "web-elb"
  security_groups = ["${aws_security_group.web.id}"]
  subnets         = ["${aws_subnet.default.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "tcp:80"
    interval            = 10
  }

  instances    = ["${aws_instance.web.*.id}"]
  idle_timeout = 400
}
