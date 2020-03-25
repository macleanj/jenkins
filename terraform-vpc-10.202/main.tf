locals {
  creator          = "Terraform"
  region           = "us-east-1"
  namespace        = "Jenkins"
  stage            = "dev"
  owner            = "Jerome Mac Lean"
  usage            = "slaves"
  resources_name   = "${local.namespace}-${local.usage}-${local.stage}"
  zone_id          = ""
  super_net        = "10.202"
}

variable "zone_id" {
  type        = "string"
  description = "Route53 Private Zone ID"
  default     = "Z1DW2UU573TTNN" # Route53 aws.internal
}

provider "aws" {
  region = local.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.9.0"
  name = local.resources_name

  cidr = "${local.super_net}.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["${local.super_net}.1.0/24", "${local.super_net}.2.0/24"]
  public_subnets  = ["${local.super_net}.11.0/24", "${local.super_net}.12.0/24"]

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Creator     = local.creator
    Owner       = local.owner
    Namespace   = local.namespace
    Environment = local.stage
    Usage       = local.usage
  }

  vpc_tags = {
    Name = "${local.namespace} ${local.usage} (${local.stage})"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = module.vpc.default_route_table_id

  tags = {
    Name        = "${local.resources_name}-default"
    Creator     = local.creator
    Owner       = local.owner
    Namespace   = local.namespace
    Environment = local.stage
    Usage       = local.usage
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = module.vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${local.resources_name}-default"
    Creator     = local.creator
    Owner       = local.owner
    Namespace   = local.namespace
    Environment = local.stage
    Usage       = local.usage
  }

  lifecycle {
    ignore_changes = ["subnet_ids"]
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.resources_name}-default"
    Creator     = local.creator
    Owner       = local.owner
    Namespace   = local.namespace
    Environment = local.stage
    Usage       = local.usage
  }
}

resource "aws_route53_zone_association" "aws_internal" {
  zone_id = "${var.zone_id}"
  vpc_id  = "${module.vpc.vpc_id}"
}
