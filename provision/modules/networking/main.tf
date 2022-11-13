// TODO break public and private into separate AZs
data "aws_availability_zones" "available" {}

module "vpc" {
  source   = "terraform-aws-modules/vpc/aws"
  for_each = var.vpc_networks

  name               = "${each.key}-vpc"
  cidr               = each.value.vpc_cidr
  private_subnets    = each.value.private_subnets
  public_subnets     = each.value.public_subnets
  enable_nat_gateway = each.value.enable_nat_gateway
  single_nat_gateway = each.value.enable_nat_gateway
  azs                = data.aws_availability_zones.available.names
  tags               = var.tags
}

module "sg-public" {
  source   = "terraform-aws-modules/security-group/aws"
  for_each = var.vpc_networks

  name                     = "${each.key}-public-sg"
  description              = "Security group for ssh service open"
  vpc_id                   = module.vpc[each.key].vpc_id
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = each.value.sg_pub.standard
  ingress_with_cidr_blocks = each.value.sg_pub.custom
}

module "sg-private" {
  source   = "terraform-aws-modules/security-group/aws"
  for_each = var.vpc_networks

  name                     = "${each.key}-private-sg"
  description              = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id                   = module.vpc[each.key].vpc_id
  ingress_cidr_blocks      = [each.value.vpc_cidr]
  ingress_rules            = each.value.sg_pub.standard
  ingress_with_cidr_blocks = each.value.sg_pub.custom
}
