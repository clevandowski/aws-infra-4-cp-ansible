variable "aws_profile" {
  type        = string
  description = "your aws profile here from ~/.aws/credentials"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  # version = "~> 2.0"
  region = var.aws_region
}

variable "authorized_ip" {
  type        = string
  description = "your public ip"
}

variable "guest_authorized_ips" {
  type = list(string)
  default = [
    "10.0.0.0/16"
    # "82.65.138.101/32",     # Maxime
    # "86.195.1.25/32"        # Eslem
  ]  
}

# Pour bastion et security_groups
variable "egress_ip" {
  type    = string
  default = "0.0.0.0/0"
}

# https://medium.com/@hmalgewatta/setting-up-an-aws-ec2-instance-with-ssh-access-using-terraform-c336c812322f
variable "id_rsa_pub_path" {
  type        = string
  description = "Chemin vers la clé publique utilisée pour se connecter aux VMs"
  default     = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key_pair"
  public_key = file(var.id_rsa_pub_path)
}

variable "instance_type_zookeeper" {
  type    = string
  default = "t3.large"
}

variable "instance_type_kafka" {
  type    = string
  default = "t3.xlarge"
}

variable "instance_type_schema_registry" {
  type    = string
  default = "t3.large"
}

# Centos official images: https://wiki.centos.org/Cloud/AWS
# Owner: 125523088429
# Name: "CentOS 7.8.2003 x86_64"
# Region: eu-west-3
variable "ami_id" {
  type    = string
  default = "ami-04552009264cbe9f4"
}

module "base" {
  source     = "./modules/base"
  aws_region = var.aws_region
  egress_ip  = var.egress_ip
}

module "security_groups" {
  source                  = "./modules/security_groups"
  vpc                     = module.base.vpc
  egress_ip               = var.egress_ip
  authorized_ip           = var.authorized_ip
  guest_authorized_ips    = var.guest_authorized_ips
}

# module "instances" {
#   source                        = "./modules/instances"
#   ami_id                        = var.ami_id
#   key_pair                      = aws_key_pair.key_pair
#   subnet_a_id                   = module.base.subnet_a_id
#   subnet_b_id                   = module.base.subnet_b_id
#   subnet_c_id                   = module.base.subnet_c_id
#   instance_type_zookeeper       = var.instance_type_zookeeper
#   instance_type_kafka           = var.instance_type_kafka
#   instance_type_schema_registry = var.instance_type_schema_registry
#   sg_id                         = module.security_groups.sg_id
#   zookeeper_sg_id               = module.security_groups.zookeeper_sg_id
#   kafka_sg_id                   = module.security_groups.kafka_sg_id
#   schemaregistry_sg_id          = module.security_groups.schemaregistry_sg_id
# }

# module "instances" {
#   source                        = "./modules/instances_minimal"
#   ami_id                        = var.ami_id
#   key_pair                      = aws_key_pair.key_pair
#   subnet_a_id                   = module.base.subnet_a_id
#   subnet_b_id                   = module.base.subnet_b_id
#   subnet_c_id                   = module.base.subnet_c_id
#   instance_type                 = "t3.large"
#   sg_id                         = module.security_groups.sg_id
#   zookeeper_sg_id               = module.security_groups.zookeeper_sg_id
#   kafka_sg_id                   = module.security_groups.kafka_sg_id
#   schemaregistry_sg_id          = module.security_groups.schemaregistry_sg_id
# }

module "instances" {
  source                        = "./modules/instances_with_bastion"
  ami_id                        = var.ami_id
  key_pair                      = aws_key_pair.key_pair
  subnet_a_id                   = module.base.subnet_a_id
  subnet_b_id                   = module.base.subnet_b_id
  subnet_c_id                   = module.base.subnet_c_id
  sg_id                         = module.security_groups.sg_id
  zookeeper_sg_id               = module.security_groups.zookeeper_sg_id
  kafka_sg_id                   = module.security_groups.kafka_sg_id
  schemaregistry_sg_id          = module.security_groups.schemaregistry_sg_id
}
