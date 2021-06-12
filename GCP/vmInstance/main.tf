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

resource "google_compute_instance" "vm_instance" {
  name         = "apache-instance"
  machine_type = "n1-standard-1"
  tags         = ["http-server", "https-server"]

  metadata_startup_script = file("installation.sh")

  # metadata = {
  #   shutdown-script = file("shutdown_script.sh")
  # }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet-us.name
    access_config {
    }
  }
}