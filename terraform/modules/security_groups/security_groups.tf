variable "vpc" {
}

variable "egress_ip" {
  type = string
}

variable "authorized_ip" {
  type = string
}

variable "guest_authorized_ips" {
  type = list(string)
}


# https://docs.confluent.io/platform/current/installation/system-requirements.html#ports
resource "aws_security_group" "zookeeper_sg" {
  tags = {
    Name = "zookeeper_sg"
  }
  name   = "zookeeper_sg"
  vpc_id = var.vpc.id
  ingress {
    self            = true
    from_port       = 2888
    to_port         = 2888
    protocol        = "tcp"
  }
  ingress {
    self            = true
    from_port       = 3888
    to_port         = 3888
    protocol        = "tcp"
  }
  ingress {
    security_groups = [aws_security_group.kafka_sg.id]
    from_port       = 2181
    to_port         = 2182
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 7770
    to_port         = 7770
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 9999
    to_port         = 9999
    protocol        = "tcp"
  }
}

# https://docs.confluent.io/platform/current/installation/system-requirements.html#ports
resource "aws_security_group" "kafka_sg" {
  tags = {
    Name = "kafka_sg"
  }
  name   = "kafka_sg"
  vpc_id = var.vpc.id
  ingress {
    self            = true
    from_port       = 9091
    to_port         = 9091
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 8090
    to_port         = 8090
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 7771
    to_port         = 7771
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 9999
    to_port         = 9999
    protocol        = "tcp"
  }
}

# https://docs.confluent.io/platform/current/installation/system-requirements.html#ports
resource "aws_security_group" "schemaregistry_sg" {
  tags = {
    Name = "schemaregistry_sg"
  }
  name   = "schemaregistry_sg"
  vpc_id = var.vpc.id
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 7772
    to_port         = 7772
    protocol        = "tcp"
  }
  ingress {
    cidr_blocks     = [var.vpc.cidr_block]
    from_port       = 9999
    to_port         = 9999
    protocol        = "tcp"
  }
}

resource "aws_security_group" "sg" {
  tags = {
    Name = "sg"
  }
  name   = "sg"
  vpc_id = var.vpc.id
  ingress {
    cidr_blocks = [var.authorized_ip]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  ingress {
    # Ouverture ssh pour les bastions & les gens
    cidr_blocks     = var.guest_authorized_ips
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
  }
  // tout le monde peut aller sur internet
  egress {
    cidr_blocks = [var.egress_ip]
    # cidr_blocks = [var.vpc.cidr_block]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  # $ dig packages.confluent.io
  # ...
  # ;; ANSWER SECTION:
  # packages.confluent.io.	31	IN	A	99.86.89.127
  # packages.confluent.io.	31	IN	A	99.86.89.59
  # packages.confluent.io.	31	IN	A	99.86.89.2
  # packages.confluent.io.	31	IN	A	99.86.89.39

  # $ dig search.maven.org
  # ...
  # ;; ANSWER SECTION:
  # search.maven.org.	43194	IN	CNAME	search-aws.maven.org.
  # search-aws.maven.org.	294	IN	CNAME	search-maven-org-alb-new2.us-east-1.elasticbeanstalk.com.
  # search-maven-org-alb-new2.us-east-1.elasticbeanstalk.com. 54 IN	A 52.203.117.103
  # search-maven-org-alb-new2.us-east-1.elasticbeanstalk.com. 54 IN	A 75.101.150.136

  # $ dig repo1.maven.org
  # ...
  # ;; ANSWER SECTION:
  # repo1.maven.org.	43198	IN	CNAME	sonatype.map.fastly.net.
  # sonatype.map.fastly.net. 28	IN	A	151.101.120.209

  # $ dig mirrorlist.centos.org
  # ...
  # ;; ANSWER SECTION:
  # mirrorlist.centos.org.	58	IN	A	35.180.43.213
  # mirrorlist.centos.org.	58	IN	A	147.75.83.237
  # mirrorlist.centos.org.	58	IN	A	85.236.43.108
  # mirrorlist.centos.org.	58	IN	A	67.219.148.138
  # mirrorlist.centos.org.	58	IN	A	147.75.69.225
  # mirrorlist.centos.org.	58	IN	A	18.225.36.18

  # $ dig mirror.centos.org
  # ...
  # ;; ANSWER SECTION:
  # mirror.centos.org.	29	IN	A	195.154.220.72

  # Note: ça n'a pas l'air très statique cette adresse de miroir mais ça à l'air de marcher
  # $ dig d36uatko69830t.cloudfront.net
  # ...
  # ;; ANSWER SECTION:
  # d36uatko69830t.cloudfront.net. 54 IN	A	13.32.144.90
  # d36uatko69830t.cloudfront.net. 54 IN	A	13.32.144.83
  # d36uatko69830t.cloudfront.net. 54 IN	A	13.32.144.193
  # d36uatko69830t.cloudfront.net. 54 IN	A	13.32.144.70
  
  # ou
  # d36uatko69830t.cloudfront.net. 22 IN	A	143.204.225.19
  # d36uatko69830t.cloudfront.net. 22 IN	A	143.204.225.60
  # d36uatko69830t.cloudfront.net. 22 IN	A	143.204.225.172
  # d36uatko69830t.cloudfront.net. 22 IN	A	143.204.225.48

  # egress {
  #   cidr_blocks = [
  #     "13.225.31.90/32",
  #     "13.225.31.12/32",
  #     "13.225.31.57/32",
  #     "13.225.31.80/32",
  #     "99.86.89.127/32",
  #     "99.86.89.59/32",
  #     "99.86.89.2/32",
  #     "99.86.89.39/32",
  #     "52.203.117.103/32",
  #     "75.101.150.136/32",
  #     "151.101.120.209/32",
  #     "35.180.43.213/32",
  #     "147.75.83.237/32",
  #     "85.236.43.108/32",
  #     "67.219.148.138/32",
  #     "147.75.69.225/32",
  #     "18.225.36.18/32",
  #     "195.154.220.72/32",
  #     "13.32.144.90/32",
  #     "13.32.144.83/32",
  #     "13.32.144.193/32",
  #     "13.32.144.70/32",
  #     "143.204.225.19/32",
  #     "143.204.225.60/32",
  #     "143.204.225.172/32",
  #     "143.204.225.48/32"
  #   ]
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  # }
  # egress {
  #   cidr_blocks = [
  #     "13.225.31.90/32",
  #     "13.225.31.12/32",
  #     "13.225.31.57/32",
  #     "13.225.31.80/32",
  #     "99.86.89.127/32",
  #     "99.86.89.59/32",
  #     "99.86.89.2/32",
  #     "99.86.89.39/32",
  #     "52.203.117.103/32",
  #     "75.101.150.136/32",
  #     "151.101.120.209/32",
  #     "35.180.43.213/32",
  #     "147.75.83.237/32",
  #     "85.236.43.108/32",
  #     "67.219.148.138/32",
  #     "147.75.69.225/32",
  #     "18.225.36.18/32",
  #     "195.154.220.72/32",
  #     "13.32.144.90/32",
  #     "13.32.144.83/32",
  #     "13.32.144.193/32",
  #     "13.32.144.70/32",
  #     "143.204.225.19/32",
  #     "143.204.225.60/32",
  #     "143.204.225.172/32",
  #     "143.204.225.48/32"
  #   ]
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  # }
}

output "sg_id" {
  value = aws_security_group.sg.id
}

output "zookeeper_sg_id" {
  value = aws_security_group.zookeeper_sg.id
}

output "kafka_sg_id" {
  value = aws_security_group.kafka_sg.id
}

output "schemaregistry_sg_id" {
  value = aws_security_group.schemaregistry_sg.id
}