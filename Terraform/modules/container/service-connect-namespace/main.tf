resource "aws_service_discovery_http_namespace" "this" {
  name        = var.name
  description = var.description

  tags = merge(
    var.common_tags,
    {
      Name = var.name
    }
  )
}
