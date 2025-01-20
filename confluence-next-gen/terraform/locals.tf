locals {
  servers = {
    "confl-pri" = {
      sub_id           = module.vpc.pub_sub_01,
      ami-id           = var.ami-id.web,
      inst_type        = var.ec2-type.web,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.web].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "confluence"
      node_num         = "01"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
    "confl-sec" = {
      sub_id           = module.vpc.pub_sub_02,
      ami-id           = var.ami-id.web,
      inst_type        = var.ec2-type.web,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.web].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "confluence"
      node_num         = "02"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
    "synch-pri" = {
      sub_id           = module.vpc.pub_sub_01,
      ami-id           = var.ami-id.sync,
      inst_type        = var.ec2-type.syn,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.syn].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "synchrony"
      node_num         = "01"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
    "synch-sec" = {
      sub_id           = module.vpc.pub_sub_02,
      ami-id           = var.ami-id.sync,
      inst_type        = var.ec2-type.syn,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.syn].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "synchrony"
      node_num         = "02"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
    //    "confl-jmp" = {
    //      sub_id           = module.vpc.pub_sub_01,
    //      ami-id           = var.ami-id.jump,
    //      inst_type        = var.ec2-type.jmp,
    //      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.jmp].id
    //      role             = "jump"
    //      node_num         = "01"
    //      volume_type      = var.ec2.volume_type
    //      root_device_size = var.ec2.root_device_size
    //    }
  }

  confluence = {
    "confl-pri" = {
      sub_id           = module.vpc.pub_sub_01,
      ami-id           = var.ami-id.web,
      inst_type        = var.ec2-type.web,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.web].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "confluence"
      node_num         = "01"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
    "confl-sec" = {
      sub_id           = module.vpc.pub_sub_02,
      ami-id           = var.ami-id.web,
      inst_type        = var.ec2-type.web,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.web].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "confluence"
      node_num         = "02"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
  }

  synchrony = {
    "synch-pri" = {
      sub_id           = module.vpc.pub_sub_01,
      ami-id           = var.ami-id.sync,
      inst_type        = var.ec2-type.syn,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.syn].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "synchrony"
      node_num         = "01"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
    "synch-sec" = {
      sub_id           = module.vpc.pub_sub_02,
      ami-id           = var.ami-id.sync,
      inst_type        = var.ec2-type.syn,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.syn].id
      iam_inst_prof    = aws_iam_instance_profile.confl-iam-instance-profile.id
      role             = "synchrony"
      node_num         = "02"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
  }

  jump = {
    "confl-jmp" = {
      sub_id           = module.vpc.pub_sub_01,
      ami-id           = var.ami-id.jump,
      inst_type        = var.ec2-type.jmp,
      sec_group        = aws_security_group.confl-sgs-stack[var.sg_keys.jmp].id
      role             = "jump"
      node_num         = "01"
      volume_type      = var.ec2.volume_type
      root_device_size = var.ec2.root_device_size
    }
  }
}