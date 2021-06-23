resource "google_compute_network" "vpc-network-brown" {
  name                    = "custom-network-brown"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet-us-brown" {
  name          = "subnet-us-central"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc-network-brown.id
}