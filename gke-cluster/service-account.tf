# this file creates a service account for the nodes and applies some iam roles to it.

// generates a new hex anytime var.cluster_name changes
resource "random_pet" "service_account" {
  keepers = {
    cluster_name = var.cluster_name
  }
  length = 1
}

// creates custom service account for nodes in node pool
resource "google_service_account" "node-pool-service-account" {
  account_id   = "np-${random_pet.service_account.id}"
  display_name = "${random_pet.service_account.keepers.cluster_name}-service-account"
  description  = "default service account for nodes in 'sca node pool'"
}


//bind the service account to necessary IAM roles 
resource "google_project_iam_member" "roles" {

  // loops through each role in the list var.roles and grants the service accoutn the role.
  for_each = toset(var.roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.node-pool-service-account.email}"
}
