# Variable para definir la región de AWS de forma flexible
variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1" # Norte de Virginia por defecto
}

# Variable para el prefijo de nomenclatura de los recursos
variable "project_name" {
  description = "Nombre base para etiquetar y nombrar los recursos de forma estandarizada"
  type        = string
  default     = "devops-mvp"
}