// this file configures a kubernetes service account to authenticate pods to google services.

//create a new google service account when the kubernetes namespace changes
resource "random_id" "service_account" {
  keepers = {
    namespace = var.namespace
  }
  byte_length =  4
}

resource "google_service_account" "kube_identity" {
  account_id   = "wli-${random_id.service_account.hex}"
  display_name = "${random_id.service_account.keepers.namespace}-service-account"
  description  = "custom service account to authenticate for kubernetes service account"
}


//bind the service account to necessary IAM roles 
resource "google_project_iam_member" "roles" {

  // loops through each role in the list var.roles and grants the service account the role.
  for_each = toset(var.roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.kube_identity.email}"
}


// create kubernetes namespace
resource "kubernetes_namespace" "dev" {
  metadata {
    name = random_id.service_account.keepers.namespace
  }
}

// generate suffix for ksa name 
resource "random_id" "ksa_gen" {
  byte_length = 4
}

// creates kubernetes service account
resource "kubernetes_service_account" "kube_sa" {
  metadata {
    name      = "${kubernetes_namespace.dev.metadata[0].name}-${random_id.ksa_gen.hex}"
    namespace = kubernetes_namespace.dev.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.kube_identity.email}"
    }
  }
}

// binds the kubernetes service account to the google service account 
resource "google_service_account_iam_binding" "ksa-bind" {
  service_account_id = google_service_account.kube_identity.id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${kubernetes_namespace.dev.metadata[0].name}/${kubernetes_service_account.kube_sa.metadata[0].name}]"
  ]
}






