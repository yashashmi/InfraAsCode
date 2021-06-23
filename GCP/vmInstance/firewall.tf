resource "google_compute_firewall" "brown-allow-ssh" {
  name    = "brown-allow-ssh"
  network = google_compute_network.vpc-network-brown.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh"]
}

resource "google_compute_firewall" "brown-allow-http" {
  name    = "brown-allow-http"
  network = google_compute_network.vpc-network-brown.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  target_tags = ["http-server"]
}