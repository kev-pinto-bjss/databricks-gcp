# Create SA
resource "google_service_account" "sa2" {
  account_id   = "${var.prefix}-sa2"
  display_name = "Service Account for Databricks Provisioning"
}

data "google_iam_policy" "this" {
  binding {
    role    = "roles/iam.serviceAccountTokenCreator"
    members = var.delegate_from
  }
}

resource "google_service_account_iam_policy" "impersonatable" {
  service_account_id = google_service_account.sa2.name
  policy_data        = data.google_iam_policy.this.policy_data
}

resource "google_project_iam_custom_role" "workspace_creator" {
  role_id = "${var.prefix}_workspace_creator"
  title   = "Databricks Workspace Creator"
  permissions = [
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.setIamPolicy",
    "iam.roles.create",
    "iam.roles.delete",
    "iam.roles.get",
    "iam.roles.update",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "serviceusage.services.get",
    "serviceusage.services.list",
    "serviceusage.services.enable",
    "compute.networks.get",
    "compute.projects.get",
    "compute.subnetworks.get",
  ]
}

data "google_client_config" "current" {}

resource "google_project_iam_member" "sa2_can_create_workspaces" {
  project = var.project_id
  role    = google_project_iam_custom_role.workspace_creator.id
  member  = "serviceAccount:${google_service_account.sa2.email}"
}

resource "google_project_service" "enable_service" {
  project = var.project_id
  service = "iamcredentials.googleapis.com"
  disable_on_destroy = true # Prevents accidental disabling during destroy
}