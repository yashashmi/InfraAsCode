resource "google_service_account" "jenkins_sa" {
  account_id   = "jenkins-sa"
  display_name = "Jenkins SA"
}

resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.jenkins_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_service_account_iam_binding" "jenkins-user" {
  service_account_id = google_service_account.jenkins_sa.name
  role               = "roles/iam.serviceAccountUser"
  members            = ["serviceAccount:${google_service_account.jenkins_sa.email}"]
}