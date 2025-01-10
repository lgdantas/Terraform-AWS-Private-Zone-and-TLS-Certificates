terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
}

# Private Zone
resource "aws_route53_zone" "private" {
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }
}

# Private CA (only if self-signed not provided)
resource "aws_acmpca_certificate_authority" "ca" {
  count = var.self_signed_cert == null ? 1 : 0

  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA256WITHRSA"

    subject {
      common_name = var.domain_name
      country     = var.ca_country
      organization = var.ca_organization
      organizational_unit = var.ca_organizational_unit
      state = var.ca_state
      locality = var.ca_locality
    }
  }

  permanent_deletion_time_in_days = 7
}

# Install CA certificate (only if self-signed not provided)
resource "aws_acmpca_certificate" "cert" {
  count = var.self_signed_cert == null ? 1 : 0

  certificate_authority_arn   = aws_acmpca_certificate_authority.ca[0].arn
  certificate_signing_request = aws_acmpca_certificate_authority.ca[0].certificate_signing_request
  signing_algorithm          = "SHA256WITHRSA"

  template_arn = "arn:aws:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 10
  }
}

resource "aws_acmpca_certificate_authority_certificate" "ca_cert" {
  count = var.self_signed_cert == null ? 1 : 0

  certificate_authority_arn = aws_acmpca_certificate_authority.ca[0].arn
  certificate              = aws_acmpca_certificate.cert[0].certificate
  certificate_chain        = aws_acmpca_certificate.cert[0].certificate_chain
}

# ACM Certificate using Private CA
resource "aws_acm_certificate" "private_ca_cert" {
  count = var.self_signed_cert == null ? 1 : 0

  domain_name               = "*.${var.domain_name}"
  certificate_authority_arn = aws_acmpca_certificate_authority.ca[0].arn

  subject_alternative_names = [var.domain_name]
}

# ACM Certificate using provided self-signed certificate
resource "aws_acm_certificate" "self_signed_cert" {
  count = var.self_signed_cert != null ? 1 : 0

  private_key       = file("${path.module}/${var.self_signed_cert.key_file}")
  certificate_body  = file("${path.module}/${var.self_signed_cert.cert_file}")
  certificate_chain = try(file("${path.module}/${var.self_signed_cert.chain_file}"), null)

  tags = {
    Name = "self-signed-certificate"
  }
}