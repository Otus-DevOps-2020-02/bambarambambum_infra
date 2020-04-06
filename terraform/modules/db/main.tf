resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["reddit-db"]
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  metadata = {
    ssh-keys = "mikh_androsov:${file(var.public_key_path)}"
  }
  network_interface {
    network = "default"
    access_config {}
  }
}
// Firewall rules
resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = var.mongo_default_port
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
