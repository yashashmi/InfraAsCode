resource "google_compute_firewall" "ssh_allow" {
  name    = "ssh-fw"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh"]
}

resource "google_compute_firewall" "custom-allow-http" {
  name    = "http-fw"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  target_tags = ["http-server"]
}