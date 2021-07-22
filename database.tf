terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "NoVA"
  region = "us-east-1"
}

# Create a VPC
resource "aws_db_instance" "orcameu_db_rds" {
  provider = aws.NoVA
  allocated_storage = 10
  engine = "postgres"
  engine_version = "11.10"
  instance_class = "db.t2.micro"
  name = "orcameu_db"
  identifier = "orcameu-db-rds"
  username = "postgres"
  password = "postgres"
  publicly_accessible = true
  skip_final_snapshot = true
  vpc_security_group_ids = ["${aws_security_group.orcameu_db_rds_sg.id}"]
}

resource "aws_security_group" "orcameu_db_rds_sg" {
  provider = aws.NoVA
  name = "orcameu-db-rds-sg"
  description = "Grupo de seguranca para a instancia do banco de dados relacional do orcameu"

  ingress {
    description = "Porta padrao do postgres"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = "${var.cidr_db}"
  }

  tags = {
    Name = "allow_postgres_port"
  }

}