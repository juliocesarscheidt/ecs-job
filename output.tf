output "log_group" {
  value = module.ecs_job.log_group
}

output "task_definition" {
  value = module.ecs_job.task_definition
}

output "available_azs" {
  value = data.aws_availability_zones.available_azs.names
}

output "workspace" {
  value = local.workspace
}

output "public_subnets" {
  value = local.public_subnets.*
}

output "private_subnets" {
  value = local.private_subnets.*
}
