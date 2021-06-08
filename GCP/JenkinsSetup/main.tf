terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "custom-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "jenkins-instance"
  machine_type = "n1-standard-1"
  tags         = ["web", "ssh", "http-server"]

  metadata_startup_script = file("installJenkins.sh")

  metadata = {
    shutdown-script = file("shutdown_script.sh")
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.jenkins_sa.email
    scopes = ["storage-rw"]
  }
}