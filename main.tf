provider "google" {
  credentials = file("/home/shinsoncjohnson1997/gcp-credentials/gcp-service-account.json")  # Path to your credentials
  project     = "bamboo-striker-431709-q3"  # Your project ID
  region      = "us-central1"                 # Your GCP region
}

resource "random_id" "instance_id" {
  byte_length = 8
}

# Define the VPC network
resource "google_compute_network" "vpc" {
  name                    = "my-company-my-app-vpc"
  auto_create_subnetworks = false
}

# Define the subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = "my-company-my-app-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24"  # Adjust CIDR as necessary
}

# Define the Google Compute Instance
resource "google_compute_instance" "vm_instance_public" {
  name         = "my-company-my-app-prod-vm-${random_id.instance_id.hex}"
  machine_type = "n1-standard-1"  # Instance type
  zone         = "us-central1-a"   # Zone
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20230905"  # Ubuntu 20.04 image
    }
  }

  network_interface {
    network = google_compute_network.vpc.name
    access_config {
      // This is necessary for assigning a public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "Hello, World!" > /var/log/startup-script.log
  EOT
}

# Optional: Define firewall rules
resource "google_compute_firewall" "default" {
  name    = "my-company-my-app-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]  # Allow SSH and HTTP traffic
  }

  source_ranges = ["0.0.0.0/0"]  # Change this to your desired IP ranges
}
