variable "company" {
  description = "The name of the company"
  type        = string
}

variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "environment" {
  description = "The environment (dev/prod/etc.)"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
}

variable "linux_instance_type" {
  description = "Linux instance type"
  type        = string
}

variable "ubuntu_2004_sku" {
  description = "Ubuntu 20.04 image SKU"
  type        = string
}

variable "app_domain" {
  description = "Application domain"
  type        = string
}
