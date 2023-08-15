module "instances" {
  source                         = "./modules/instance"
  for_each                       = var.instances
  ami                            = each.value.ami
  instance_type                  = each.value.instance_type
  key_name                       = each.value.key_name
  vpc_security_group_ids         = each.value.vpc_security_group_ids
  subnet_id                      = each.value.subnet_id
  disable_api_termination        = each.value.disable_api_termination
  iam_instance_profile           = each.value.iam_instance_profile
  associate_public_ip            = each.value.associate_public_ip
  ebs_root_volume_size           = each.value.ebs_root_volume_size
  ebs_root_delete_on_termination = each.value.ebs_root_delete_on_termination
  ebs_blocks                     = each.value.ebs_blocks
  tags                           = local.tags

  #   depends_on = [module.vpc]
}



# module "subnet" {
# source            = "./modules/subnet"
# for_each          = var.subnet
#   vpc_id            = module.vpc[each.value.vpc_id].vpc_id
#   cidr_block        = each.value.cidr_block
#   availability_zone = each.value.availability_zone
# tags              = local.tags

#   depends_on = [module.vpc]
# }
