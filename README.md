# Terraform AWS Private Zone and TLS Certificates

# AWS Certificate Management Terraform Module

This Terraform module creates a Route53 private zone and manages AWS certificates and private certificate authorities, providing flexible options for both private CA setup and self-signed certificate management.

## Features

- Private Certificate Authority (CA) creation and management
- Self-signed certificate import and management
- Integration with AWS Certificate Manager (ACM)
- Private hosted zone configuration
- Secure defaults with RSA 2048-bit keys and SHA256 signing

## Providers

- Terraform >= 1.8.0
- AWS provider ~> 5.0

## Prerequisites

- AWS account with appropriate permissions
- VPC for private hosted zone

## Usage

### Basic Usage with Private CA

```hcl
module "certificate_management" {
  source = "path/to/module"
  
  vpc_id      = "vpc-12345678"
  domain_name = "example.internal"
  
  ca_organization = "My Company"
  ca_country     = "US"
}
```

### Using Self-Signed Certificates

```hcl
module "certificate_management" {
  source = "path/to/module"
  
  vpc_id      = "vpc-12345678"
  domain_name = "example.internal"
  
  self_signed_cert = {
    cert_file  = "path/to/certificate.pem"
    key_file   = "path/to/private-key.pem"
    chain_file = "path/to/chain.pem"  # Optional
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID for the private hosted zone | string | - | yes |
| domain_name | Domain name for the private hosted zone | string | - | yes |
| self_signed_cert | Self-signed certificate configuration | object | null | no |
| ca_country | Country code for CA certificate | string | "US" | no |
| ca_organization | Organization name for CA certificate | string | "My Organization" | no |
| ca_organizational_unit | Organizational unit for CA certificate | string | "IT" | no |
| ca_state | State for CA certificate | string | "California" | no |
| ca_locality | Locality for CA certificate | string | "San Francisco" | no |

## Module Behavior

The module implements a mutually exclusive approach to certificate management:

- If `self_signed_cert` is null (default), it creates a private CA infrastructure
- If `self_signed_cert` is provided, it imports the existing self-signed certificate

## AWS Service Integration

This module integrates with the following AWS services:
- AWS Certificate Manager (ACM)
- AWS Certificate Manager Private Certificate Authority (ACM PCA)
- Amazon Route 53 (for private hosted zones)
- Amazon VPC

## Security Considerations

- Uses RSA 2048-bit keys for strong encryption
- Implements SHA256 signing for certificates
- Configures a 7-day permanent deletion time for certificate authorities
- Integrates with AWS private hosted zones for internal use

## License

This module is released under the MIT License. See the LICENSE file for details.