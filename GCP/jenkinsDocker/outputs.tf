output "secret" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.JenkinsUser.secret_data
}