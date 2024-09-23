provider "google" {
  credentials = file(var.GOOGLE_APPLICATION_CREDENTIALS)  # Use the variable for credentials
  project     = var.project_id                               # Add your project ID variable
  region      = var.gcp_region
}

resource "random_id" "instance_id" {
  byte_length = 8
}

# Define the VPC network
resource "google_compute_network" "vpc" {
  name = "${var.company}-${var.app_name}-vpc"
  auto_create_subnetworks = false
}

# Define the subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = "${var.company}-${var.app_name}-subnet"
  region        = var.gcp_region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24"  # Adjust CIDR as necessary
}

# Define the Google Compute Instance
resource "google_compute_instance" "vm_instance_public" {
  name         = "${lower(var.company)}-${lower(var.app_name)}-${var.environment}-vm${random_id.instance_id.hex}"
  machine_type = var.linux_instance_type
  zone         = var.gcp_zone
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = var.ubuntu_2004_sku
    }
  }

  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.network_subnet.name
    access_config {}
  }

  metadata_startup_script = file("path/to/your/startup-script.sh")  # Adjust the path to your startup script
}
