// list providers
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    random = {
      source = "hashicorp/random"
    }
    google = {
      source = "hashicorp/google"
      version = ">=3.89.0"
    }
  }
}

// configure remote backend as a terraform cloud workspace
terraform {
  backend "remote" {
    organization = "daphney"

    workspaces {
      name = "sca-kubernetes"
    }
  }
}


// configure providers
provider "google" {
  /* the provider credentials are stored as athe environment variable GOOGLE_CREDENTIALS 
  in the terraform cloud workspace specified above */
  project = var.project_id
  region = var.region
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.sca_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.sca_cluster.master_auth[0].cluster_ca_certificate,
  )
}