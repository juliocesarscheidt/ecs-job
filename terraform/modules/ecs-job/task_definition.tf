resource "aws_ecs_task_definition" "task-definition" {
  family = var.task_name
  # role for task execution, which will be used to pull the image, create log stream, start the task, etc
  execution_role_arn = var.execution_role_arn
  # role for task application, to be used by the application itself in execution time, it's optional
  task_role_arn = var.task_role_arn
  container_definitions = jsonencode([
    {
      name : var.task_name
      image : "${var.docker_registry}/${var.task_name}:${var.task_image_tag}",
      portMappings = [for port in var.task_container_ports : {
        containerPort = port
        hostPort      = port
      }],
      command : var.task_container_command,
      environment : length(var.task_container_environment) > 0 ? var.task_container_environment : null,
      cpu : var.task_container_cpu,
      memory : var.task_container_memory,
      memoryReservation : 128,
      essential : true,
      logConfiguration = {
        logDriver = "awslogs",
        Options = {
          "awslogs-region"        = var.aws_region,
          "awslogs-group"         = aws_cloudwatch_log_group.scheduled-task-log-group.name,
          "awslogs-stream-prefix" = "ecs",
        }
      }
    }
  ])
  network_mode             = "awsvpc"
  cpu                      = var.task_container_cpu
  memory                   = var.task_container_memory
  requires_compatibilities = ["FARGATE"]
  tags = merge(var.tags, {
    "Name" = var.task_name
  })
  depends_on = [
    aws_cloudwatch_log_group.scheduled-task-log-group
  ]
}
