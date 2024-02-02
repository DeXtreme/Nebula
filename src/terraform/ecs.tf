resource "aws_ecs_cluster" "cluster" {
  name = "nebula_cluster"

  setting{
    name = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  tags = {
    Terraform = true
  }
}

resource "aws_ecs_cluster_capacity_providers" "provider" {
    cluster_name = aws_ecs_cluster.cluster.name
    capacity_providers = [ "FARGATE" ]
}


resource "aws_ecs_task_definition" "task" {
  family = "nebula"
  requires_compatibilities = [ "FARGATE" ]
  cpu = 0.25
  memory = 512
  network_mode = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
  }
  ephemeral_storage {
    size_in_gib = 21
  }
  container_definitions = jsonencode([{
    name = "nebula_api"
    image = aws_ecr_repository.repo.repository_url
    portMappings = [
        {
            containerPort = 80
        }
    ]
    environment = [
        {
            name = "DEBUG"
            value = "False"
        },
        {
            name = "SECRET_KEY"
            value = data.aws_secretsmanager_secret_version.secret_key.secret_string
        },
        {
            name = "POSTGRES_DB"
            value = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).db_name
        },
        {
            name = "POSTGRES_HOST"
            value = aws_db_instance.db.address
        },
        {
            name = "POSTGRES_USERNAME"
            value = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).username
        },
        {
            name = "POSTGRES_PASSWORD"
            value = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string).password
        }
    ]
  }])
}

resource "aws_ecs_service" "nebula" {
  name = "nebula_service"
  task_definition = aws_ecs_task_definition.task.arn
  cluster = aws_ecs_cluster.cluster.id
  desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
      subnets = module.vpc.public_subnets
      security_groups = [ aws_security_group.ecs_sg.id ]
      assign_public_ip = true
    }

}


resource "aws_security_group" "ecs_sg" {
    name = "ECS security group"
    vpc_id = module.vpc.vpc_id

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "80"
        to_port = "80"
        protocol = "tcp"   
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "0"
        to_port = "0"
        protocol = "-1"   
    }
}
