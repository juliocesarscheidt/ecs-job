resource "aws_ecs_task_definition" "task-definition" {
  family             = var.task_name
  task_role_arn      = aws_iam_role.task-role.arn
  execution_role_arn = aws_iam_role.execution-role.arn
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
    aws_iam_role.task-role,
    aws_cloudwatch_log_group.scheduled-task-log-group
  ]
}
