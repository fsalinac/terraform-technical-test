output "harbor_service_name" {
  value = kubernetes_service.harbor.metadata[0].name
}