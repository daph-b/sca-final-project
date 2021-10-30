// this file contains the data sources used in this project

// get gcloud authentication information
data "google_client_config" "default" {}


// get information about cluster
data "google_container_cluster" "sca_cluster" {
  name = var.cluster_name
  location = var.cluster_zone
}


//get data about the cloud sql instance we want to connect to
data "google_sql_database_instance" "app_db" {
    name = var.db_instance
} 

