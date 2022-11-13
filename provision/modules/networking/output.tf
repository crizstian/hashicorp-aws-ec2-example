output "vpc" {
  value = { for key, value in module.vpc : key => merge(value, {
    sg_pub_id  = module.sg-public[key].security_group_id
    sg_priv_id = module.sg-private[key].security_group_id
  }) }
}
