resource "random_id" "sql_id" {
  byte_length = 4
}

// creates a zonal PostgreSQL cloud SQL instance
resource "google_sql_database_instance" "primary" {
  name = "sca-${random_id.sql_id.hex}"
  database_version = var.database_version
  region           = var.region
  deletion_protection = false

  settings {
    tier              = var.tier
    availability_type = var.availability
    activation_policy = "ALWAYS"
   

    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.default_vpc.id
    }
  }
  depends_on = [
    google_service_networking_connection.vpc_peering
  ]
}

// creates a database in the cloud sql instance
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.primary.name
}

//creates user for the db instance
resource "google_sql_user" "admin_user" {
  name     = var.db_user
  instance = google_sql_database_instance.primary.name
  password = var.db_pass
}



