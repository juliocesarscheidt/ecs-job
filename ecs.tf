resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.ecs_cluster_name
  tags = merge(var.tags, {
    "Name" = var.ecs_cluster_name
  })
  lifecycle {
    create_before_destroy = true
  }
}
