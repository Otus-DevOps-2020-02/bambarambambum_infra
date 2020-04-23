// IP
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
// SSH Keys
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = var.public_key
}
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params { image = var.app_disk_image }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
  metadata = {
    ssh-keys = "mikh_androsov:${file(var.public_key_path)}"
  }
  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = "mikh_androsov"
    agent       = false
    private_key = file(var.private_key_path)
  }
#  // Provision
#  provisioner "file" {
#    content      = templatefile("${path.module}/files/puma.tpl", {
#      reddit-db = var.reddit-db
#      })
#    destination = "/tmp/puma.service"
#  }
#  provisioner "remote-exec" {
#    script = "${path.module}/files/deploy.sh"
#  }
}
// Firewall rules
resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = var.port_app
  }
  source_ranges = var.source_ranges
  target_tags   = ["reddit-app"]
}
