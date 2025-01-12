variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "pub_subnets" {
  type = map(string)
  default = {
    us-east-1a = "10.0.1.0/24"
    us-east-1b = "10.0.2.0/24"
  }
}

variable "all_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "project" {
  type = string
  default = "confluence-build"
}

variable "av_zones" {
  type = map(string)
  default = {
    zone1 = "us-east-1a"
    zone2 = "us-east-1b"
  }
}
