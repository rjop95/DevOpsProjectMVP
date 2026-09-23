# Configuración general de Terraform y la versión mínima requerida del CLI
terraform {
  required_version = ">= 1.5.0" # Requiere Terraform versión 1.5 o superior
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Descarga el proveedor oficial de AWS mantenido por HashiCorp
      version = "~> 5.0"        # Utiliza la versión 5.x del proveedor de AWS
    }
  }
}

# Configuración del proveedor de AWS y sus credenciales de conexión
provider "aws" {
  region = var.aws_region # Región geográfica donde se crearán los recursos (ej. us-east-1)

  # Etiquetas globales aplicadas automáticamente a todos los recursos creados (Gobernanza)
  default_tags {
    tags = {
      Project   = "DevOpsProjectMVP"
      ManagedBy = "Terraform"
    }
  }
}