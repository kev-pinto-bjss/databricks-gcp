terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "1.58.0"
    }
    google = {
      source = "hashicorp/google"
      version = "6.10.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-903134114827"
    prefix="dbricks"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "databricks" {
  alias                  = "accounts"
  host                   = "https://accounts.gcp.databricks.com"
  google_service_account = var.databricks_google_service_account
  account_id             = var.databricks_account_id
}