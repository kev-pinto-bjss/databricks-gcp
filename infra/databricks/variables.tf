variable "project_id" {
  type    = string
}

variable "region" {
  type    = string
}

variable "zone" {
  type    = string
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID"
}

variable "databricks_google_service_account" {
    type        = string
    description = "SA Registered with Databricks"
}
