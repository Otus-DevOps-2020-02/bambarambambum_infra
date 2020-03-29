terraform {
  required_version = "0.12.8"
}

provider "google" {
  version = "2.15"
  project = var.project
  region = var.region
}

// My instansces
resource "google_compute_instance" "app" {
  count = 2
  name = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone = var.zone
  tags = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }
  metadata = {
    ssh-keys = "mikh_androsov:${file(var.public_key_path)}"
    }

  network_interface {
    network = "default"
    access_config {}
  }

  connection {
  type = "ssh"
  host = self.network_interface[0].access_config[0].nat_ip
  user = "mikh_androsov"
  agent = false
  private_key = file(var.private_key_path)
}

  provisioner "file" {
source = "files/puma.service"
destination = "/tmp/puma.service"
  }

provisioner "remote-exec" {
script = "files/deploy.sh"
}
}
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}

// SSH Keys
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "${join("\n", var.public_key)}"
}

// 9292 check
resource "google_compute_http_health_check" "tcp-9292-connect" {
  name               = "tcp-9292-connect"
  description        = "Check app health"
  request_path       = "/"
  port               = var.port_app
  check_interval_sec = 10
  timeout_sec        = 5
}

// Resource pool
resource "google_compute_target_pool" "app-pool" {
  name             = "app-pool"
  region           = var.region
  instances = google_compute_instance.app.*.self_link
  health_checks = [
    google_compute_http_health_check.tcp-9292-connect.name
  ]
}

// Forwarding rule
resource "google_compute_forwarding_rule" "lb" {
  name                  = "app-pool-lb"
  target                = google_compute_target_pool.app-pool.self_link
  port_range            = "9292"
}
