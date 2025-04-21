resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway resources conditionally created
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-gw-${count.index}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  count  = var.enable_nat_gateway ? length(var.private_subnet_cidrs) : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index % length(aws_nat_gateway.nat)].id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private_association" {
  count          = var.enable_nat_gateway ? length(aws_subnet.private_subnet) : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index % length(aws_route_table.private_rt)].id
}
