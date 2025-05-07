terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

module "harbor" {
  source = "./modules/harbor"

  namespace       = "harbor"
  storage_class   = "kadalu"         # Cambiar si el StorageClass es otro
  harbor_hostname = var.harbor_hostname
}

module "app" {
  source = "./modules/app"

  app_name         = "testapp"
  image_repository = var.app_image
  namespace        = "flavio-salinas"
  ingress_host     = var.app_hostname
}