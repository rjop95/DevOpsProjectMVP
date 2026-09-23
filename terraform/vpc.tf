# 1. Creación de la red privada virtual (VPC) principal que aislará toda nuestra infraestructura
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # Rango total de IPs disponibles para la red
  enable_dns_hostnames = true          # Permite que los recursos tengan nombres de dominio internos
  enable_dns_support   = true          # Habilita la resolución DNS dentro de la VPC

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# 2. Puerta de enlace de internet (Internet Gateway) para conectar la VPC con el mundo exterior
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# 3. Subredes Públicas (Zona A y B) - Aquí vivirá únicamente el Application Load Balancer con acceso a internet
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true # Asigna IP pública automática a los recursos en esta subred

  tags = {
    Name = "${var.project_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}

# 4. Subredes Privadas (Zona A y B) - Aquí correrán los contenedores Fargate y la base de datos (sin IP pública)
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_name}-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.project_name}-private-subnet-2"
  }
}

# 5. Tabla de enrutamiento pública para dirigir el tráfico de internet hacia el Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Asociar la subred pública 1 a la tabla de rutas de internet
resource "aws_route_table_association" "pub_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Asociar la subred pública 2 a la tabla de rutas de internet
resource "aws_route_table_association" "pub_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}