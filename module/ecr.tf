resource "aws_ecr_repository" "this" {
  name = var.registry_name
}