variable "ami_id" {
}
variable "key_pair" {
}
variable "subnet_a_id" {
}
variable "subnet_b_id" {
}
variable "subnet_c_id" {
}
variable "sg_id" {
}
variable "zookeeper_sg_id" {
}
variable "kafka_sg_id" {
}
variable "schemaregistry_sg_id" {
}

resource "aws_instance" "bastion_1" {
  tags = {
    Zone = "b"
    Name = "bastion_1"
    Components = "bastion"
    Cluster = "1"
  }
  ami                         = "ami-06d9c6325dbcc4e62"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "node_a_1" {
  tags = {
    Zone = "a"
    Name = "node_a_1"
    Components = "zookeeper,kafka,schema_registry"
    Cluster = "1"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 1
    })
    KafkaConfiguration = jsonencode({
      broker_id = 1
    })
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = "t3.large"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_a_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}

resource "aws_instance" "node_b_1" {
  tags = {
    Zone = "b"
    Name = "node_b_1"
    Components = "zookeeper,kafka,schema_registry"
    Cluster = "1"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 2
    })
    KafkaConfiguration = jsonencode({
      broker_id = 2
    })
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = "t3.large"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}

resource "aws_instance" "node_c_1" {
  tags = {
    Zone = "c"
    Name = "node_c_1"
    Cluster = "1"
    Components = "zookeeper,kafka"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 3
    })
    KafkaConfiguration = jsonencode({
      broker_id = 3
    })
  }
  ami                         = var.ami_id
  instance_type               = "t3.large"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_c_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}

resource "aws_instance" "bastion_2" {
  tags = {
    Zone = "b"
    Name = "bastion_2"
    Components = "bastion"
    Cluster = "2"
  }
  ami                         = "ami-06d9c6325dbcc4e62"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "node_a_2" {
  tags = {
    Zone = "a"
    Name = "node_a_2"
    Components = "zookeeper,kafka,schema_registry"
    Cluster = "2"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 1
    })
    KafkaConfiguration = jsonencode({
      broker_id = 1
    })
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = "t3.large"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_a_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}

resource "aws_instance" "node_b_2" {
  tags = {
    Zone = "b"
    Name = "node_b_2"
    Components = "zookeeper,kafka,schema_registry"
    Cluster = "2"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 2
    })
    KafkaConfiguration = jsonencode({
      broker_id = 2
    })
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = "t3.large"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}

resource "aws_instance" "node_c_2" {
  tags = {
    Zone = "c"
    Name = "node_c_2"
    Cluster = "2"
    Components = "zookeeper,kafka"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 3
    })
    KafkaConfiguration = jsonencode({
      broker_id = 3
    })
  }
  ami                         = var.ami_id
  instance_type               = "t3.large"
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_c_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}


# resource "aws_instance" "bastion_3" {
#   tags = {
#     Zone = "b"
#     Name = "bastion_3"
#     Components = "bastion"
#     Cluster = "3"
#   }
#   ami                         = "ami-06d9c6325dbcc4e62"
#   instance_type               = "t3.micro"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id]
#   root_block_device {
#     volume_size = 32
#   }
# }

# resource "aws_instance" "node_a_3" {
#   tags = {
#     Zone = "a"
#     Name = "node_a_3"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "3"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 1
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 1
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_a_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_b_3" {
#   tags = {
#     Zone = "b"
#     Name = "node_b_3"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "3"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 2
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 2
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_c_3" {
#   tags = {
#     Zone = "c"
#     Name = "node_c_3"
#     Cluster = "3"
#     Components = "zookeeper,kafka"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 3
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 3
#     })
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_c_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }


# resource "aws_instance" "bastion_4" {
#   tags = {
#     Zone = "b"
#     Name = "bastion_4"
#     Components = "bastion"
#     Cluster = "4"
#   }
#   ami                         = "ami-06d9c6325dbcc4e62"
#   instance_type               = "t3.micro"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id]
#   root_block_device {
#     volume_size = 32
#   }
# }

# resource "aws_instance" "node_a_4" {
#   tags = {
#     Zone = "a"
#     Name = "node_a_4"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "4"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 1
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 1
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_a_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_b_4" {
#   tags = {
#     Zone = "b"
#     Name = "node_b_4"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "4"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 2
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 2
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_c_4" {
#   tags = {
#     Zone = "c"
#     Name = "node_c_4"
#     Cluster = "4"
#     Components = "zookeeper,kafka"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 3
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 3
#     })
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_c_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }


# resource "aws_instance" "bastion_5" {
#   tags = {
#     Zone = "b"
#     Name = "bastion_5"
#     Components = "bastion"
#     Cluster = "5"
#   }
#   ami                         = "ami-06d9c6325dbcc4e62"
#   instance_type               = "t3.micro"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id]
#   root_block_device {
#     volume_size = 32
#   }
# }

# resource "aws_instance" "node_a_5" {
#   tags = {
#     Zone = "a"
#     Name = "node_a_5"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "5"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 1
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 1
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_a_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_b_5" {
#   tags = {
#     Zone = "b"
#     Name = "node_b_5"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "5"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 2
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 2
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_c_5" {
#   tags = {
#     Zone = "c"
#     Name = "node_c_5"
#     Cluster = "5"
#     Components = "zookeeper,kafka"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 3
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 3
#     })
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_c_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }


# resource "aws_instance" "bastion_6" {
#   tags = {
#     Zone = "b"
#     Name = "bastion_6"
#     Components = "bastion"
#     Cluster = "6"
#   }
#   ami                         = "ami-06d9c6325dbcc4e62"
#   instance_type               = "t3.micro"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id]
#   root_block_device {
#     volume_size = 32
#   }
# }

# resource "aws_instance" "node_a_6" {
#   tags = {
#     Zone = "a"
#     Name = "node_a_6"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "6"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 1
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 1
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_a_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_b_6" {
#   tags = {
#     Zone = "b"
#     Name = "node_b_6"
#     Components = "zookeeper,kafka,schema_registry"
#     Cluster = "6"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 2
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 2
#     })
#     SchemaRegistryConfiguration = jsonencode({})
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_b_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }

# resource "aws_instance" "node_c_6" {
#   tags = {
#     Zone = "c"
#     Name = "node_c_6"
#     Cluster = "6"
#     Components = "zookeeper,kafka"
#     ZookeeperConfiguration = jsonencode({
#       zookeeper_id = 3
#     })
#     KafkaConfiguration = jsonencode({
#       broker_id = 3
#     })
#   }
#   ami                         = var.ami_id
#   instance_type               = "t3.large"
#   key_name                    = var.key_pair.key_name
#   subnet_id                   = var.subnet_c_id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
#   root_block_device {
#     volume_size = 64
#   }
# }
