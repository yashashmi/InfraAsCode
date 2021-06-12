data "google_secret_manager_secret_version" "JenkinsUser" {
  provider = google-beta
  secret   = "JenkinsUser"
  version  = "1"
}
