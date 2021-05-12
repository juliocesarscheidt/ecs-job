resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.vpc_0.id
  route_table_ids   = [aws_route_table.public_route_table.id]
  service_name      = "com.amazonaws.sa-east-1.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "s3_endpoint"
  }
  depends_on = [aws_vpc.vpc_0, aws_route_table.public_route_table]
}
