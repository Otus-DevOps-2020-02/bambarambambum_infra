variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
variable "machine_type" {
  description = "Standart machine type"
  default     = "f1-micro"
}
variable "mongo_default_port" {
  description = "MongoDB default port"
  default     = ["27017"]
}
