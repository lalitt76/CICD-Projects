## EFS - Elastic file System Play

# create efs file system
resource "aws_efs_file_system" "confl-efs-fs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  tags = {
    Name    = "confl-efs-fs"
    Project = "confluence"
  }
}

# provide efs mount target on each subnet
resource "aws_efs_mount_target" "confl-efs-mount" {
  for_each        = var.av_zones
  file_system_id  = aws_efs_file_system.confl-efs-fs.id
  subnet_id       = module.vpc.public_subnets[each.value].id
  security_groups = [aws_security_group.confl-sgs-stack[var.sg_keys.efs].id]
}

# provide efs access point
resource "aws_efs_access_point" "confl-efs-ap" {
  file_system_id = aws_efs_file_system.confl-efs-fs.id
  tags = {
    Name    = "confl-efs-ap"
    Project = "confluence"
  }
}