terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.11.0"
    }

    google-beta = ">=3.8"
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone

}

provider "google-beta" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone

}

data "template_file" "template-file-startup" {
  template = file("startup.sh")
  vars = {
    jenkinsUser = "${data.google_secret_manager_secret_version.secret-manager-jenkins.secret_data}"
  }
}

resource "google_compute_instance" "ci-jenkins" {
  name         = "jenkins-instance"
  machine_type = "e2-medium"
  #machine_type = "f1-micro"
  tags = ["web", "ssh", "http-server"]

  metadata_startup_script = data.template_file.template-file-startup.rendered

  #metadata_startup_script = "echo ENVVAR=${data.google_secret_manager_secret_version.my-secret.secret_data} >> /etc/profile"
  # metadata = {
  #   shutdown-script = file("shutdown_script.sh")
  # }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet-us-central.name
    access_config {
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.sa-jenkins.email
    scopes = ["cloud-platform", "storage-rw"]
  }
}