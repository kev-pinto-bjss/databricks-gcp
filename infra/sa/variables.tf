variable "project_id" {
  type    = string
}

variable "region" {
  type    = string
}

variable "zone" {
  type    = string
}


variable "prefix" {
  type        = string
  description = "Prefix to use in generated VPC name"
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID"
}

variable "workspace_name" {
  type        = string
  description = "Name of the workspace to create"
  default     = "dataexp_poc"
}

variable "delegate_from" {
  description = "Allow either user:user.name@example.com, group:deployers@example.com or serviceAccount:sa1@project.iam.gserviceaccount.com to impersonate created service account"
  type        = list(string)
}