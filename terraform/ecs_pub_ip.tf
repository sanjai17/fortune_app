#ecs_pub_ip.tf

provider "aws" {
  region = "us-east-1"
}

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "dev-my-fortune-app"
}



# ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "dev_fortune_task_family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = "arn:aws:iam::558737725740:role/ecs_execution_role"
  task_role_arn      = "arn:aws:iam::558737725740:role/ecs_task_role"

  cpu    = "1024"   # CPU value for the task
  memory = "3072"   # Memory value for the task

  container_definitions = jsonencode([
    {
      name      = "new_fortune_container"
      image     = "558737725740.dkr.ecr.us-east-1.amazonaws.com/fortune-api:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          appProtocol   = "http"
        }
      ]
      runtimePlatform  = "LINUX_CONTAINER"
      cpu_architecture = "X86_64"
      os_family        = "LINUX"
    }
  ])
}


# ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = "dev_fortune_ecs_service_name"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE"  # Replace with the capacity provider you want to use
    weight            = 1                # Adjust the weight according to your requirements
  }

  network_configuration {
    subnets          = ["subnet-06c9adcc3b8002f5d"]
    security_groups  = ["sg-0ab2d103efd2b3220"]
    assign_public_ip = true
  }
}

