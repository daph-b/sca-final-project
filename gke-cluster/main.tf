// this file creates a multi-zonal cluster with detached node pool cutom service account using VPC-native routing using the project's default network

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


// creates a public cluster with VPC-nativenetwork routing
resource "google_container_cluster" "sca-cluster" {
  name = random_pet.service_account.keepers.cluster_name

  // location of the control plane. zonal clusters have 1 replica of the control plane in a single zone.
  location = var.cluster_zone

  // to use external node pool, i create and delete the default
  // node pool as i cant create the cluster without the default node pool
  initial_node_count       = 1
  remove_default_node_pool = true

  enable_shielded_nodes = true

  // to allow VPC-native ... so i can use the container-native ingress to creat NEGs for my backend services
  ip_allocation_policy {

    // left it empty for it to be automatically allocated. i could have specified a cidr block, or a netmask
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }
  networking_mode = "VPC_NATIVE"

  // use the default network and the corresponding subnet for my zone
  network    = "default"
  subnetwork = ""

  // set the version for the control plane
  release_channel {
    channel = "REGULAR"
  }
  min_master_version = var.master_version
 
  // allows kubernetes service account authenticate as a google service account
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }
}


// creates a muti zone node pool for the cluster
resource "google_container_node_pool" "sca-node-pool" {
  name = "${random_pet.service_account.keepers.cluster_name}"

  // references the sca-cluster 
  cluster = random_pet.service_account.keepers.cluster_name

  // specify different zones within the same region as the control plane(ie zonal cluster)
  node_locations = var.node_zones

  node_config {

    // grant platform-wide access and apply restrictions using iam permissions(principle of least priviledge)
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = google_service_account.node-pool-service-account.email

    //set the macchine type for the nodes in the node pool
    machine_type = var.machine_type
    
    // enables workload identity on the nodes in the node pool
    workload_metadata_config {
      mode = "GKE_METADATA"  
  }

  }
  // allow google to manage the health of the nodes
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  // set rules for how the nodes should be upgraded
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  // set node count to one and configure its ability to automatically grow or shrink.
  initial_node_count = 1
  autoscaling {
    min_node_count = 1  # try and comeback and use if logic to enable or disable autoscaling
    max_node_count = 2
  }
}

