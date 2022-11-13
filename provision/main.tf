module "networking" {
  source       = "./modules/networking"
  vpc_networks = var.vpc_networks
}

module "ssh-key" {
  source    = "./modules/ssh-key"
  namespace = terraform.workspace
}

module "ec2" {
  source     = "./modules/ec2"
  namespace  = terraform.workspace
  vpc        = module.networking.vpc[terraform.workspace]
  sg_pub_id  = module.networking.vpc[terraform.workspace].sg_pub_id
  sg_priv_id = module.networking.vpc[terraform.workspace].sg_priv_id
  key_name   = module.ssh-key.key_name
}
