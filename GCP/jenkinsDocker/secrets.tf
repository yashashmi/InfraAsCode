data "google_secret_manager_secret_version" "secret-manager-jenkins" {
  provider = google-beta
  secret   = "JenkinsUser"
  version  = "1"
}

resource "google_secret_manager_secret" "secret-manager-jenkins-service-key" {
  provider  = google-beta
  secret_id = "JenkinsServiceAccountKey"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-manager-version-jenkins-service-key" {
  provider = google-beta
  secret   = google_secret_manager_secret.secret-manager-jenkins-service-key.id
  #secret_data = jsonencode(file("../credentials/projectCreator.json"))
  secret_data = local_file.local-file-key-sa-jenkins.content
}

resource "google_secret_manager_secret" "secret-manager-appengine-service-key" {
  provider  = google-beta
  secret_id = "AppEngineServiceAccountKey"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-manager-version-appengine-service-key" {
  provider = google-beta
  secret   = google_secret_manager_secret.secret-manager-appengine-service-key.id
  #secret_data = jsonencode(file("../credentials/projectCreator.json"))
  secret_data = local_file.local-file-key-sa-appengine.content
}