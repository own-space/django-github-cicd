# Configure Terraform cloud provider and workspace
terraform {
  cloud {
    organization = "superriya-sumits-blog"

    workspaces {
      name = "GitHub-Actions-CICD"
    }
  }
}

# Configure provider AWS and region
provider "aws" {
  region = "eu-west-2"
}

# Configure AWS VPC
resource "aws_vpc" "django_vpc" {
  cidr_block = var.vpc_cidr
}   # end resource aws_vpc

# create the Subnet
resource "aws_subnet" "django_subnet" {
  vpc_id                  = aws_vpc.django_vpc.id
  cidr_block              = var.subnetCIDRblock_a
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
  tags = {
    Name = "Django-gh-actions-test-A"
  }
} # end resource aws_subnet

#second subnet
resource "aws_subnet" "django_subnet2" {
  vpc_id                  = aws_vpc.django_vpc.id
  cidr_block              = var.subnetCIDRblock_b
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone_b
  tags = {
    Name = "Django-gh-actions-test-B"
  }
} # end resource aws_subnet

# Create the Security Group
resource "aws_security_group" "django_security_group" {
  vpc_id       = aws_vpc.django_vpc.id
  name         = "django-tf-security-group"
  description  = "Security group for django, allowing port 22 and 4000"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 

  # allow ingress of port 4000
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
  }
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Django-gh-actions-test"
  }
} # end resource aws_security_group

# create VPC Network access control list
resource "aws_network_acl" "django_security_ACL" {
  vpc_id = aws_vpc.django_vpc.id
  subnet_ids = [ aws_subnet.django_subnet.id ]
  # allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  # allow egress ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 443
    to_port    = 443
  }
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 443
    to_port    = 443
  }
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = "Django-gh-actions-test"
    method   = "terraform"
  }
} # end resource aws_network_acl

# Create the Internet Gateway
resource "aws_internet_gateway" "django_igw" {
  vpc_id = aws_vpc.django_vpc.id
} # end resource aws_internet_gateway

# Create the Route Table
resource "aws_route_table" "django_route_table" {
  vpc_id = aws_vpc.django_vpc.id
} # end resource aws_route_table

# Create the Internet Access
resource "aws_route" "django_igw_route" {
  route_table_id = aws_route_table.django_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id = aws_internet_gateway.django_igw.id
} # end resource aws_route

# # Create the Route Table Association with the Internet Gateway
# resource "aws_route_table_association" "django_route_table_association" {
#   gateway_id = aws_internet_gateway.django_igw.id
#   route_table_id = aws_route_table.django_route_table.id
# } # end resource aws_route_table_association

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/django-app-*","django-app-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["245411993826"] # Canonical
}


# Public ssh key for the web server
resource "aws_key_pair" "deployer" {
  key_name   = "github-terraform-ec2-deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5truLA8Fnt7ZvzCtkRuC+h3YeYYuiiWWqbjj6cz5S6lHRr86JdQ1ZxJ2b7So2ZwBKYxJqKJHNk/vbc5Z67tA+EUewIoNRVJNHftmJ2ZoqdrNxRWg3LNaBNJYPxtl8UsZ5Gkmew/N2wus+joyDoiUuYsV/X2K/5EwJfNGgLKeSxnrOv2B8CTSpE+pxS8BuG7ghn7/6YoXGWKS32Er+1DWI5klc1ZtZTy7bBiJPz8sEOqMW+1JfQaf9A8n3gljJAqRyxSYj2VMQv30XEEx8UKE5Zy5qR6H3q3tP0MOdzNSRqQUBWPcUosJ9CGusXmBa02dNXzc9M2f+xCZhbf1uomFSfVehN4LvVn+plM2KId+OVDc/OYpDhfV9dY67eOOtPkLT3AOy73UnZdFUGksPDhiSVgYzHFRHkI9Ji7O+ON+oCDtrGphPOVNRcM6/5MEsk0jkjOKp/jL9CgOb0D4S4KnPV5JRy7wKLsBCROkUUjV1TTC/aFmT/btCUxO9+9i5gI35pWe1FvO0Jx99eNJeiFsZ2fmvUNtIuVOxlAn268vZQRH+2V7isCs9FhAhY4PJtc7+GL042NErW68weHlYCZ4YIOxJ3dAipuXshUMPKe1jWv1+eh0X7BVilhBkTIzbmcyPP7Ahr7Pee2NiVDhgel6CxQtS57Iwtu09vPX4JqRjGQ== sumitsontakke@Sumits-MacBook-Pro-2.local"
}

data "template_file" "user_data" {
  template = file("userdata/django_webserver.sh")
}

resource "aws_launch_configuration" "django_app_launch_conf" {
  name_prefix     = var.lc_name_prefix
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [ "${aws_security_group.django_security_group.id}" ]
  key_name        = "${aws_key_pair.deployer.key_name}"
  user_data       = data.template_file.user_data.rendered
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

# Creating Security Group for ELB
resource "aws_security_group" "elb_sg" {
  name        = "sg-elb-${var.lc_name_prefix}"
  description = "Demo Module"
  vpc_id      = "${aws_vpc.demovpc.id}"
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS access from anywhere
  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the ELB
resource "aws_elb" "web_elb" {
  name = "web-elb-${var.lc_name_prefix}"
  security_groups = [
    "${aws_security_group.elb_sg.id}"
  ]
  subnets = [
    "${aws_subnet.djanog_subnet.id}",
    "${aws_subnet.djanog_subnet_2.id}"
  ]
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:4000/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "4000"
    instance_protocol = "http"
  }
}

# Create the Auto Scaling Group
resource "aws_autoscaling_group" "django_app_asg" {
  #availability_zones   = [ var.availabilityZone, var.availabilityZone_b ]
  name_prefix          = var.lc_name_prefix
  desired_capacity     = 1
  max_size             = 1
  min_size             = 0
  health_check_type    = "ELB"
  load_balancers       = "${aws_elb.web_elb.id}"
  launch_configuration = "${aws_launch_configuration.django_app_launch_conf.name}"
  vpc_zone_identifier  = [ aws_subnet.django_subnet.id, aws_subnet.django_subnet2.id ]
}
