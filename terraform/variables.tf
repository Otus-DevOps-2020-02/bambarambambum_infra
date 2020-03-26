variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  default     = "europe-west1"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}
variable "public_key" {
  type        = "list"
  description = "Public Key in RSA"
  default     = ["mikh_androsov:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3ZGfEhcYLORqG4R8fYssFdXYmSOsw6HjM1rfqc9zS4golKhrCz+OXM0vQ3XCPraA+msD2N0MY88CI9m0LjkN1s+qY4AcEmcepeIg/IMqJXG/IdazVA7tDFD6/TMlgjXO9dDAkrDa/p/MuW113jHWkd89N+T5dGsirsRDnA7yDmJwJB+HFH//mY4ZUwNPqKJE0MilnSBLt+7rACe1jXFbNfrYMgXNoGWybUwnXDv8LusOHnO4+sDnVxy4NN6kKwHT6RDx4SYrGe0LsBwK5xY0ji5RM0jUq+NLTRcXeAOqP2zLfUM4wLn1+Js9vOYLjefQQdHqCPv8ygnyIWjAceLlX mikh_androsov"]
}
