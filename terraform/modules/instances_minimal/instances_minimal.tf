variable "key_pair" {
}
variable "subnet_a_id" {
}
variable "subnet_b_id" {
}
variable "subnet_c_id" {
}
variable "instance_type" {
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

# ec2 instances
resource "aws_instance" "node_a" {
  tags = {
    Zone = "a"
    Name = "node_a"
    Components = "zookeeper,kafka,schema_registry"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 1
    })
    KafkaConfiguration = jsonencode({
      broker_id = 1
    })
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_a_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}

resource "aws_instance" "node_b" {
  tags = {
    Zone = "b"
    Name = "node_b"
    Components = "zookeeper,kafka,schema_registry"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 2
    })
    KafkaConfiguration = jsonencode({
      broker_id = 2
    })
    SchemaRegistryConfiguration = jsonencode({})
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_b_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}

resource "aws_instance" "node_c" {
  tags = {
    Zone = "c"
    Name = "node_c"
    Components = "zookeeper,kafka"
    ZookeeperConfiguration = jsonencode({
      zookeeper_id = 3
    })
    KafkaConfiguration = jsonencode({
      broker_id = 3
    })
  }
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair.key_name
  subnet_id                   = var.subnet_c_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id, var.zookeeper_sg_id, var.kafka_sg_id, var.schemaregistry_sg_id]
  root_block_device {
    volume_size = 64
  }
}
