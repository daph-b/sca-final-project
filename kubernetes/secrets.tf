// API token for IEX cloud
resource "kubernetes_secret" "iex_cred" {
  metadata {
    name = "iex-cred"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }
  data = {
    "token" = var.api_key
  }
} 

//creates secret for the tls cert and key
resource "kubernetes_secret" "tls_cred" {
  metadata {
            name = "tls-cred"
            namespace = kubernetes_namespace.dev.metadata[0].name
          }

          data = {
            #"tls.crt" = file("${path.root}/.tls/revevellidan.com_ssl_certificate.cer")
            "tls.crt" = var.tls_crt
            "tls.key" = var.tls_key
            #"tls.key" = file("${path.root}/.tls/_.revevellidan.com_private_key.key")
          }

          type = "kubernetes.io/tls"
}

