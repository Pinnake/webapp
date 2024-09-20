# Generate a unique ID for the instance
resource "random_id" "instance_id" {
  byte_length = 8
}

# Template file for metadata startup script
data "template_file" "linux-metadata" {
  template = file("path/to/your/startup-script.sh")  # Adjust the path to your script
}

# Define the VPC network
resource "google_compute_network" "vpc" {
  name = "${var.company}-${var.app_name}-vpc"
  auto_create_subnetworks = false
}

# Define the subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = "${var.company}-${var.app_name}-subnet"
  region        = var.gcp_region  # Make sure you have a variable for the region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24"  # Adjust CIDR as necessary
}

# Define the Google Compute Instance
resource "google_compute_instance" "vm_instance_public" {
  name         = "${lower(var.company)}-${lower(var.app_name)}-${var.environment}-vm${random_id.instance_id.hex}"
  machine_type = var.linux_instance_type
  zone         = var.gcp_zone
  hostname     = "${var.app_name}-vm${random_id.instance_id.hex}.${var.app_domain}"
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = var.ubuntu_2004_sku
    }
  }

  metadata_startup_script = data.template_file.linux-metadata.rendered

  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.network_subnet.name
    access_config {}
  }
}
