resource "kubernetes_namespace" "harbor" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "harbor" {
  metadata {
    name      = "harbor"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "harbor"
      }
    }

    template {
      metadata {
        labels = {
          app = "harbor"
        }
      }

      spec {
        container {
          name  = "harbor"
          image = "goharbor/harbor-core:v2.10.0"

          port {
            container_port = 8080
          }

          volume_mount {
            name       = "harbor-storage"
            mount_path = "/data"
          }
        }

        volume {
          name = "harbor-storage"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "harbor" {
  metadata {
    name      = "harbor"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "harbor"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}