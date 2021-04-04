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

variable "ami_id" {
}
variable "instance_type_zookeeper" {
}
variable "instance_type_kafka" {
}
variable "instance_type_schema_registry" {
}

# ec2 instances
resource "aws_instance" "zookeeper_a" {
  tags = {
    Zone = "a"
    Name = "zookeeper_a"
    Components = "zookeeper"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 1
    })
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_zookeeper
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_a_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "zookeeper_b" {
  tags = {
    Zone = "b"
    Name = "zookeeper_b"
    Components = "zookeeper"
    zookeeper_id = 2
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 2
    })
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_zookeeper
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "zookeeper_c" {
  tags = {
    Zone = "c"
    Name = "zookeeper_c"
    Components = "zookeeper"
    zookeeper_id = 3
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 3
    })
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_zookeeper
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_c_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "kafka_a" {
  tags = {
    Zone = "a"
    Name = "kafka_a"
    Components = "kafka"
    KafkaConfiguration = jsonencode({
      broker_id = 1
    })
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_kafka
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_a_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.kafka_sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "kafka_b" {
  tags = {
    Zone = "b"
    Name = "kafka_b"
    Components = "kafka"
    KafkaConfiguration = jsonencode({
      broker_id = 2
    })
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_kafka
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.kafka_sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "kafka_c" {
  tags = {
    Zone = "c"
    Name = "kafka_c"
    Components = "kafka"
    KafkaConfiguration = jsonencode({
      broker_id = 3
    })
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_kafka
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_c_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.kafka_sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "schema_registry_a" {
  tags = {
    Zone = "a"
    Name = "schema_registry_a"
    Components = "schema_registry"
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_kafka
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_a_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 32
  }
}

resource "aws_instance" "schema_registry_b" {
  tags = {
    Zone = "b"
    Name = "schema_registry_b"
    Components = "schema_registry"
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type_kafka
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 32
  }
}
