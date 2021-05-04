variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "ecs-job-cluster"
}

variable "task_schedule_expression" {
  description = "Task schedule expression in cron/rate format"
  type        = string
  default     = "cron(0/30 * * * ? *)"
}

variable "task_name" {
  description = "Task name"
  type        = string
}

variable "task_image_tag" {
  description = "Task image tag/version"
  type        = string
  default     = "latest"
}

variable "docker_registry" {
  description = "Docker registry"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}
