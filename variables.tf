variable "kubeconfig_path" {
  description = "Ruta al archivo kubeconfig para acceder al clúster"
  type        = string
  default = "/Users/fmsalinasc/Desktop/Archivos para la prueba/Test2/kubeconfig2.yml"
}

variable "harbor_hostname" {
  description = "Dominio donde se expondrá Harbor"
  type        = string
  default     = "harbor.miking.duckdns.org"
}

variable "app_image" {
  description = "Imagen completa de la app (con ruta al Harbor)"
  type        = string
  default     = "fmsalinasc/testapp:test"
}

variable "app_hostname" {
  description = "Dominio para la app desplegada"
  type        = string
  default     = "app.miking.duckdns.org"
}