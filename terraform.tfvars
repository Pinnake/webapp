variable "GOOGLE_APPLICATION_CREDENTIALS" {
  description = "gcp-terraform"
  type        = string
}

variable "project_id" {
  description = "bamboo-striker-431709-q3"
  type        = string
}

variable "gcp_region" {
  description = "us-central1 (Iowa)"
  type        = string
}

variable "gcp_zone" {
  description = "Any"
  type        = string
}

variable "n1-standard-1" {
  description = "The instance type for Linux VM"
  type        = string
}

variable "ubuntu_2004_sku" {
  description = "The SKU for Ubuntu 20.04"
  type        = string
}


