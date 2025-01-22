# environment
variable "infra_env" {
  type    = string
  default = "dev"
}

# ssl url
variable "domain" {
  type    = string
  default = "www.thetyagi.com"
}

# infra zones aws_subnet.confl-pub-sub
variable "av_zones" {
  type = map(string)
  default = {
    zone1 = "us-east-1a"
    zone2 = "us-east-1b"
  }
}

# ec2 ami type
variable "ami-id" {
  type = map(string)
  default = {
    web  = "ami-01816d07b1128cd2d"
    sync = "ami-01816d07b1128cd2d"
    jump = "ami-01816d07b1128cd2d"
  }
}

# ec2 instance types
variable "ec2-type" {
  type = map(string)
  default = {
    web = "t2.large" # "t2.medium"
    syn = "t2.micro"
    jmp = "t2.micro"
  }
}

# cidr all
variable "cidr_all" {
  type    = string
  default = "0.0.0.0/0"
}

# ec2 meta data
variable "ec2" {
  type = map(any)
  default = {
    key              = "devops-key"
    user             = "ec2-user"
    volume_type      = "gp3"
    root_device_size = 12
  }
}

# my ip address
variable "my_ip" {
  type    = string
  default = "67.80.148.143/32"
}

# project name
variable "project" {
  type    = string
  default = "confluence-build"
}

variable "sg_keys" {
  type = map(string)
  default = {
    jmp = "jmp-sg"
    web = "web-sg"
    syn = "syn-sg"
    alb = "alb-sg"
    rds = "rds-sg"
    efs = "efs-sg"
  }
}

# List of map of object of security groups
variable "security_group_stack" {
  type = map(object({
    sg_name     = string
    description = string
  }))
  default = {
    jmp-sg = {
      sg_name     = "confl-jmp-sg"
      description = "security group for jump server"
    },
    web-sg = {
      sg_name     = "confl-web-sg"
      description = "security group for confluence web server"
    },
    syn-sg = {
      sg_name     = "confl-syn-sg"
      description = "security group for synchrony server"
    },
    alb-sg = {
      sg_name     = "confl-alb-sg"
      description = "security group for application load balancer"
    },
    rds-sg = {
      sg_name     = "confl-rds-sg"
      description = "security group for rds postgress server"
    },
    efs-sg = {
      sg_name     = "confl-efs-sg"
      description = "security group for rds efs server"
    }
  }
}

# list of ingress variables of all security groups
variable "confl_ingress_sgs_vars_stack" {
  type = map(object({
    security_group               = string
    description                  = string
    from_port                    = number
    to_port                      = number
    ip_protocol                  = string
    cidr_ipv4                    = string
    referenced_security_group_id = string
  }))
  default = {
    allow-ssh-my-ip = {
      security_group               = "jmp-sg"
      description                  = "ingress for confl jump station"
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "67.80.148.143/32"
      referenced_security_group_id = null
    },
    allow-ssh-from-my-ip = {
      security_group               = "web-sg"
      description                  = "ingress for confl jump station"
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "67.80.148.143/32"
      referenced_security_group_id = null
    },
    allow-ssh-jump = {
      security_group               = "web-sg"
      description                  = "ingress of jump to web srv"
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow-http-from-lb = {
      security_group               = "web-sg"
      description                  = "ingress of web for incoming http"
      from_port                    = 8090
      to_port                      = 8090
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow_hazelcast_web = {
      security_group               = "web-sg"
      description                  = "ingress of web to allow traffic for hazelcast"
      from_port                    = 5801
      to_port                      = 5801
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow-ssh-jump-sync = {
      security_group               = "syn-sg"
      description                  = "ingress of jump to sync srv"
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow_synchrony = {
      security_group               = "syn-sg"
      description                  = "ingress to allow traffic for synchrony"
      from_port                    = 8091
      to_port                      = 8091
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow_hazelcast_sync = {
      security_group               = "syn-sg"
      description                  = "ingress to allow traffic for sync hazelcast"
      from_port                    = 5701
      to_port                      = 5701
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow_sync_cluster = {
      security_group               = "syn-sg"
      description                  = "ingress to allow traffic for sync cluster"
      from_port                    = 25500
      to_port                      = 25500
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow_sync_multi = {
      security_group               = "syn-sg"
      description                  = "ingress to allow traffic for sync multi port"
      from_port                    = 54327
      to_port                      = 54327
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    allow-http-from-all = {
      security_group               = "alb-sg"
      description                  = "ingress of load balancer for http"
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    },
    confl-db-sg = {
      security_group               = "rds-sg"
      description                  = "ingress to for postgres rds instance; allow traffic from ec2"
      from_port                    = 5432
      to_port                      = 5432
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    },
    confl-efs-sg = {
      security_group               = "efs-sg"
      description                  = "ingress to for efs; allow traffic from ec2"
      from_port                    = 2049
      to_port                      = 2049
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "10.0.0.0/16"
      referenced_security_group_id = null
    }
  }
}

# list of egress variables of all security groups
variable "confl_egress_sgs_vars_stack" {
  type = map(object({
    security_group               = string
    description                  = string
    from_port                    = number
    to_port                      = number
    ip_protocol                  = string
    cidr_ipv4                    = string
    referenced_security_group_id = string
  }))
  default = {
    allow-all-egress-jmp = {
      security_group               = "jmp-sg"
      description                  = "egress for confl jump station"
      from_port                    = 0
      to_port                      = 0
      ip_protocol                  = "-1"
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    },
    allow-all-egress-web = {
      security_group               = "web-sg"
      description                  = "egress of confluence web server"
      from_port                    = 0
      to_port                      = 0
      ip_protocol                  = "-1"
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    },
    allow-all-egress-syn = {
      security_group               = "syn-sg"
      description                  = "egress of synchrony server"
      from_port                    = 0
      to_port                      = 0
      ip_protocol                  = "-1"
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    },
    allow-all-egress-rds = {
      security_group               = "rds-sg"
      description                  = "egress of rds server"
      from_port                    = 0
      to_port                      = 0
      ip_protocol                  = "-1"
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    },
    allow-all-egress-efs = {
      security_group               = "efs-sg"
      description                  = "egress of efs"
      from_port                    = 0
      to_port                      = 0
      ip_protocol                  = "-1"
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    },
    allow-all-egress-lb = {
      security_group               = "alb-sg"
      description                  = "egress of lb"
      from_port                    = 0
      to_port                      = 0
      ip_protocol                  = "-1"
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }
}

# meta data for rds
variable "rds" {
  type = map(any)
  default = {
    db_instance     = "db.t3.medium" # "db.t3.micro"
    identifier      = "confluence"
    eng             = "postgres"
    eng_ver         = "16.3"
    storage_size    = 12
    pub_acc         = false
    skip_final_snap = true
    multi_az        = false
    db_user         = "postgres"
    db_pass         = "AQICAHhrvJMQc0F7yNbOWq789cm5RaOaL5B+N41EjXJEouE+HwHPlddINGlFg0aD/W9ySUp8AAAAZjBkBgkqhkiG9w0BBwagVzBVAgEAMFAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM0Q/J6F05mMZppcrOAgEQgCMoY6Mjk3dt4OR7rShz573ppy43DOviOOhys7UzD7/ZTxVVow=="
  }
}
