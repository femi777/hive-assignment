resource "aws_vpc" "this" {
  
  cidr_block = var.cidr_blocks
tags = merge(local.tags, 
    { 
        Name  = "hive-vpc"
    
    }
  )
}

# Internet Gateway for public access
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, 
    { 
        Name  = "hive-igw"
    
    }
  )
  depends_on = [ aws_vpc.this ]
}
  


# Route table for public subnets
resource "aws_route_table" "public" {
  
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.tags, {
    Name = "${var.project_name}-public-rt"
  })

  depends_on = [aws_vpc.this, aws_internet_gateway.this]
}

# Associate public subnets with route table
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.this

  subnet_id = each.value.id

  # Use the vpc key from flattened_subnets map to get correct route table
  route_table_id = aws_route_table.public.id
}

