# ECS job
module "ecs_job" {
  source = "./modules/ecs-job"

  aws_region               = var.aws_region
  ecs_cluster_arn          = aws_ecs_cluster.ecs-cluster.arn
  task_schedule_expression = var.task_schedule_expression
  task_name                = var.task_name
  task_image_tag           = var.task_image_tag
  docker_registry          = var.docker_registry
  task_subnet_ids          = aws_subnet.private_subnet.*.id
  task_security_group_ids  = [aws_security_group.task-sg.id]
  task_assign_public_ip    = false
  execution_role_arn       = aws_iam_role.execution-role.arn
  task_role_arn            = aws_iam_role.task-role.arn
  tags                     = var.tags
}
