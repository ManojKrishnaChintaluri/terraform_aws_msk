provider "aws" {
  region = "us-east-2"
  profile = "CW-DATABUS-DEV"
}

resource "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"
tags = {
    Name = "dev-observation-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  availability_zone = "us-east-2a"
  cidr_block        = "172.31.1.0/24"
  tags = {
    Name = "dev-observation-msk-subnet-1"
  }
  vpc_id            = aws_vpc.vpc.id

}

resource "aws_subnet" "subnet2" {
  availability_zone = "us-east-2b"
  cidr_block        = "172.31.2.0/24"
  tags = {
    Name = "dev-observation-msk-subnet-2"
  }
  vpc_id            = aws_vpc.vpc.id

}

resource "aws_subnet" "subnet3" {
  availability_zone = "us-east-2c"
  cidr_block        = "172.31.3.0/24"
  tags = {
    Name = "dev-observation-msk-subnet-3"
  }
  vpc_id            = aws_vpc.vpc.id

}

resource "aws_security_group" "securitygroup" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_msk_cluster" "dev-observation-msk-cluster" {
  cluster_name           = "dev-observation-msk-cluster"
  kafka_version          = "2.8.0"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 10
    client_subnets = [
      aws_subnet.subnet1.id,
      aws_subnet.subnet2.id,
      aws_subnet.subnet3.id,
    ]
    security_groups = [aws_security_group.securitygroup.id]

  }
}
