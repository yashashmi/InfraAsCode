data "google_secret_manager_secret_version" "JenkinsUser" {
  provider = google-beta
  secret   = "JenkinsUser"
  version  = "1"
}

resource "google_secret_manager_secret" "secret_jenkins_ce" {
  provider  = google-beta
  secret_id = "JenkinsServiceAccountKey"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_jenkins_ce_version" {
  provider = google-beta
  secret   = google_secret_manager_secret.secret_jenkins_ce.id
  #secret_data = jsonencode(file("../credentials/projectCreator.json"))
  secret_data = local_file.jenkins_ce_sa_key_content.content
}