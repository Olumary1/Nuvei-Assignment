# Create a security group to allow traffic on ports 80 and 443 from the internet
resource "aws_security_group" "sg" {
  name_prefix = "sg"
  vpc_id      = aws_vpc.nuvei_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an ELB that listens on ports 80 and 443, and attaches to the public subnets
resource "aws_elb" "nuvei_elb" {
  name            = "${var.business_name}-elb"
  subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups = [aws_security_group.sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 443
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"
    #ssl_certificate_id = "arn:aws:iam::123456789012:server-certficate/example-cert"
  }

  tags = {
    Name = "${var.business_name}-elb"
  }
}


