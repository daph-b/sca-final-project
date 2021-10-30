// retrieve information about the default vpc
data "google_compute_network" "default_vpc" {
  name = "default"
}


//reserve internal static ip-range 
resource "google_compute_global_address" "peering_address" {
  provider = google-beta

  name          = "default-vpc-sql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  project = var.project_id
  prefix_length = var.prefix_length
  network       = data.google_compute_network.default_vpc.id
}


// setup private vpc connection between the default network and google cloud sql
resource "google_service_networking_connection" "vpc_peering" {
  provider = google-beta

  network                 = data.google_compute_network.default_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_address.name]
}