resource "aws_cloudwatch_log_group" "scheduled-task-log-group" {
  retention_in_days = 1
  name              = "/aws/ecs/${var.task_name}"
}

resource "aws_cloudwatch_event_rule" "cloudwatch-event-rule" {
  name                = "cloudwatch-event-rule"
  schedule_expression = var.task_schedule_expression
  tags = merge(var.tags, {
    "Name" = "cloudwatch-event-rule-${random_id.random.hex}"
  })
}

resource "aws_cloudwatch_event_target" "cloudwatch-event-target" {
  target_id = "cloudwatch-event-target"
  rule      = aws_cloudwatch_event_rule.cloudwatch-event-rule.name
  arn       = var.ecs_cluster_arn
  role_arn  = aws_iam_role.schedule-task-role.arn
  ecs_target {
    task_count          = var.task_count
    task_definition_arn = aws_ecs_task_definition.task-definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = var.task_subnet_ids
      security_groups  = var.task_security_group_ids
      assign_public_ip = var.task_assign_public_ip
    }
  }
  depends_on = [
    aws_cloudwatch_event_rule.cloudwatch-event-rule,
    aws_ecs_task_definition.task-definition,
    aws_iam_role.schedule-task-role
  ]
}
