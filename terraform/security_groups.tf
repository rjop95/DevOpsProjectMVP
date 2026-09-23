# 1. Firewall para el Application Load Balancer (ALB)
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Permitir trafico web publico hacia el balanceador"
  vpc_id      = aws_vpc.main.id

  # Permitir tráfico HTTP entrante desde cualquier IP de internet
  ingress {
    description = "HTTP desde internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir tráfico HTTPS entrante desde cualquier IP de internet
  ingress {
    description = "HTTPS desde internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir salida libre de tráfico hacia cualquier destino
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# 2. Firewall para los contenedores en Fargate (FastAPI)
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Permitir trafico al contenedor exclusivamente desde el ALB"
  vpc_id      = aws_vpc.main.id

  # REGLA DE SEGURIDAD CRÍTICA: Solo acepta conexiones que provengan del Security Group del ALB
  ingress {
    description     = "Trafico desde el ALB al puerto de FastAPI"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-tasks-sg"
  }
}

# 3. Firewall para la Base de Datos (PostgreSQL)
resource "aws_security_group" "database" {
  name        = "${var.project_name}-db-sg"
  description = "Permitir conexion a PostgreSQL exclusivamente desde Fargate"
  vpc_id      = aws_vpc.main.id

  # REGLA DE SEGURIDAD CRÍTICA: Solo acepta consultas de red que vengan de las tareas de Fargate
  ingress {
    description     = "PostgreSQL desde ECS Tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}