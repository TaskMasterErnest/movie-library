# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


# MAKE SURE TO MANUALLY CREATE A BUCKET IN GOOGLE CLOUD STORAGE
# THIS MAKES WORKING WITH IT IN THE NEXT STAGE POSSIBLE

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "watchlist-tfstate"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}