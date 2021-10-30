// this file contains the services, ingress and other conectivity associated resources.


//reserve a public ip for my application
resource "google_compute_global_address" "flask_app_ip" {
  name = "flask-app-ip"
}

// service of type ClusterIP for the deployment
resource "kubernetes_service" "flask-service" {
  metadata {
    name = "flask-service-1"
    namespace = kubernetes_namespace.dev.metadata[0].name
    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = "{\"default\": \"my-backendconfig\"}"
    }
  }
  spec {
    selector = {
      run = "uwsgi"
      app = "flask"
    }
    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
  depends_on = [
    kubernetes_deployment.sca-project-depl,
    kubernetes_manifest.backendconfig
  ]
}

//expose the service to the internet
resource "kubernetes_ingress" "flask-ingress" {
  metadata {
    name = "flask-ingress"
    namespace = kubernetes_namespace.dev.metadata[0].name
    annotations = {
      "networking.gke.io/v1beta1.FrontendConfig" = "my-frontendconfig"
      "kubernetes.io/ingress.global-static-ip-name" = "flask-app-ip"
    }
  }
  spec {
    tls {
      secret_name = kubernetes_secret.tls_cred.metadata[0].name
    }
    backend {
      service_name = kubernetes_service.flask-service.metadata[0].name
      service_port = 5000
    }
  }
  depends_on = [
    kubernetes_secret.tls_cred,
    kubernetes_service.flask-service,
    kubernetes_manifest.frontendconfig
  ]
}


