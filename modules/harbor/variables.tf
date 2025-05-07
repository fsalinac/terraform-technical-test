variable "namespace" {
  description = "Namespace donde se desplegará Harbor"
  type        = string
}

variable "storage_class" {
  description = "Nombre del StorageClass a usar (ej. kadalu)"
  type        = string
}

variable "harbor_hostname" {
  description = "Dominio por el cual se accederá a Harbor"
  type        = string
}