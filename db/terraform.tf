terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.89.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=3.89.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

terraform {
  backend "remote" {
    organization = "daphney"

    workspaces {
      name = "sca-database"
    }
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

