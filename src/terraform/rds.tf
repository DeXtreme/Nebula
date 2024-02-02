resource "aws_db_instance" "db" {
    allocated_storage = 10
    instance_class = "db.t2.micro"
    db_name = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).db_name
    db_subnet_group_name = module.vpc.database_subnet_group_name
    username = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).username
    password = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).password
    multi_az = true
    vpc_security_group_ids = [aws_security_group.db_sg.id]

    tags = {
      Terraform = true
    }
}

resource "aws_security_group" "db_sg" {
    name = "DB security group"
    vpc_id = module.vpc.vpc_id

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "5432"
        to_port = "5432"
        protocol = "tcp"   
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "0"
        to_port = "0"
        protocol = "-1"   
    }
}