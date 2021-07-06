resource "google_service_account" "sa-appengine" {
  account_id   = "appengine-sa"
  display_name = "App Engine SA"
  description  = "Created by Terraform. Service Account for managing App Engine Deployments."
}

resource "local_file" "local-file-key-sa-appengine" {
  content  = base64decode(google_service_account_key.service-account-key-appengine.private_key)
  filename = "${path.module}/appengine_ce_sa_key.json"
}


resource "google_service_account_key" "service-account-key-appengine" {
  service_account_id = google_service_account.sa-appengine.name
}

resource "google_project_iam_member" "app-engine-deployer" {
  project = var.project
  role    = "roles/appengine.deployer"
  member  = "serviceAccount:${google_service_account.sa-appengine.email}"
}

####
resource "google_project_iam_member" "app-engine-admin" {
  project = var.project
  role    = "roles/appengine.appAdmin"
  member  = "serviceAccount:${google_service_account.sa-appengine.email}"
}

resource "google_project_iam_member" "app-engine-cloud-build-editor" {
  project = var.project
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.sa-appengine.email}"
}

resource "google_project_iam_member" "app-engine-sa-user" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.sa-appengine.email}"
}

resource "google_project_iam_member" "app-engine-storage-object-admin" {
  project = var.project
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.sa-appengine.email}"
}