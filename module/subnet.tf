resource "aws_subnet" "this" {
  for_each = local.flattened_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "subnet-${each.value.name}-${each.value.vpc}"
    }
  )
}
