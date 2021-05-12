output "log_group" {
  value = aws_cloudwatch_log_group.scheduled-task-log-group
}

output "task_definition" {
  value = aws_ecs_task_definition.task-definition
}
