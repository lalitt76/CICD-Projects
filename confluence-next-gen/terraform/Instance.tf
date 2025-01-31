module "vpc" {
  source = "./modules/vpc"
}

resource "aws_instance" "confl-servers" {
  for_each               = local.servers
  ami                    = each.value.ami-id
  instance_type          = each.value.inst_type
  subnet_id              = each.value.sub_id
  vpc_security_group_ids = [each.value.sec_group]
  key_name               = var.ec2.key
  iam_instance_profile   = each.value.iam_inst_prof
  root_block_device {
    volume_size = each.value.root_device_size
    volume_type = each.value.volume_type
  }
  tags = {
    Name    = "${each.key}-${var.infra_env}-${each.value.node_num}"
    Project = var.project
    Env     = var.infra_env
    Role    = each.value.role
  }
}

//resource "aws_ebs_volume" "confl-vol" {
//  for_each          = var.av_zones
//  availability_zone = each.value
//  size              = 3
//  tags = {
//    Name    = "confl-vol-${each.key}"
//    Project = var.project
//  }
//}
//
//resource "aws_volume_attachment" "confl-attach-vol" {
//  for_each    = local.confluence
//  device_name = "/dev/xvdf"
//  instance_id = aws_instance.confl-servers[each.key].id
//  volume_id   = each.key == "confl-pri" ? aws_ebs_volume.confl-vol["zone1"].id : aws_ebs_volume.confl-vol["zone2"].id
//}
