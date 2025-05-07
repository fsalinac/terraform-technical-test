variable "app_name" {
  description = "Nombre de la app"
  type        = string
}

variable "image_repository" {
  description = "Imagen con ruta completa (Harbor)"
  type        = string
}

variable "namespace" {
  description = "Namespace donde desplegar la app"
  type        = string
}

variable "ingress_host" {
  description = "Dominio para el Ingress"
  type        = string
}