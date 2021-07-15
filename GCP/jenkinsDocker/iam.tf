resource "google_service_account" "sa-jenkins" {
  account_id   = "jenkins-sa"
  display_name = "Jenkins SA"
  description  = "Created by Terraform. Service Account for managing Jenkins instance."
}

resource "local_file" "local-file-key-sa-jenkins" {
  content  = base64decode(google_service_account_key.service-account-key-jenkins.private_key)
  filename = "${path.module}/jenkins_ce_sa_key.json"
}


resource "google_service_account_key" "service-account-key-jenkins" {
  service_account_id = google_service_account.sa-jenkins.name
}

resource "google_project_iam_member" "storage-admin" {
  project = var.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.sa-jenkins.email}"
}

resource "google_project_iam_member" "compute-admin" {
  project = var.project
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.sa-jenkins.email}"
}

resource "google_project_iam_member" "secret-accessor" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.sa-jenkins.email}"
}

resource "google_project_iam_member" "secret-manager-viewer" {
  project = var.project
  role    = "roles/secretmanager.viewer"
  member  = "serviceAccount:${google_service_account.sa-jenkins.email}"
}

resource "google_project_iam_member" "monitoring-metric-writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.sa-jenkins.email}"
}

resource "google_project_iam_member" "logging-log-writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.sa-jenkins.email}"
}