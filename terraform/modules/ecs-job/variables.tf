variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "task_schedule_expression" {
  description = "Task schedule expression in cron/rate format"
  type        = string
  default     = "cron(0/5 * * * ? *)"
}

variable "task_name" {
  description = "Task name"
  type        = string
}

variable "task_count" {
  description = "Task count"
  type        = number
  default     = 1
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

variable "task_container_ports" {
  description = "Task container ports"
  type        = list
  default     = []
}

variable "task_container_command" {
  description = "Task container starting command"
  type        = list
  # e.g. [80]
  default = []
}

variable "task_container_environment" {
  description = "Task container environment"
  type        = list(map(string))
  # e.g. [{ "name" : "NODE_ENV", "value" : "development" }]
  default = []
}

variable "task_container_cpu" {
  description = "Task container CPU amount"
  type        = number
  default     = 512
}

variable "task_container_memory" {
  description = "Task container memory amount"
  type        = number
  default     = 1024
}

variable "task_subnet_ids" {
  type        = list
  description = "The subnet IDs for task"
}

variable "task_security_group_ids" {
  type        = list
  description = "The security group IDs for task"
}

variable "task_assign_public_ip" {
  description = "Should we assign a public IP to the task?"
  type        = bool
  default     = true
}

variable "execution_role_arn" {
  description = "ARN of the execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  # e.g. { "BusinessUnit" : "ABC" }
  default = {}
}
