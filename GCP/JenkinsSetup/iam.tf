resource "google_service_account" "jenkins_sa" {
  account_id   = "jenkins-sa"
  display_name = "Jenkins SA"
}

resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.jenkins_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "storage-admin" {
  project = "my-second-project-314314"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"
}

resource "google_project_iam_member" "compute-admin" {
  project = "my-second-project-314314"
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"
}