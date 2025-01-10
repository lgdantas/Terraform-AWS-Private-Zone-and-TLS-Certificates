variable "vpc_id" {
  type        = string
  description = "VPC ID for the private hosted zone"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the private hosted zone"
}

variable "self_signed_cert" {
  type = object({
    cert_file  = string
    key_file   = string
    chain_file = optional(string)
  })
  description = "Self-signed certificate files details. If not provided, a private CA will be created."
  default     = null
}

variable "ca_country" {
  type        = string
  description = "Country for the CA certificate"
  default     = "US"
}

variable "ca_organization" {
  type        = string
  description = "Organization for the CA certificate"
  default     = "My Organization"
}

variable "ca_organizational_unit" {
  type        = string
  description = "Organizational Unit for the CA certificate"
  default     = "IT"
}

variable "ca_state" {
  type        = string
  description = "State for the CA certificate"
  default     = "California"
}

variable "ca_locality" {
  type        = string
  description = "Locality for the CA certificate"
  default     = "San Francisco"
}