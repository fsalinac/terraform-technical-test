output "harbor_url" {
  value = "https://${var.harbor_hostname}"
}

output "app_url" {
  value = "https://${var.app_hostname}"
}