output "private_zone_id" {
  value       = aws_route53_zone.private.id
  description = "The ID of the private hosted zone"
}

output "private_zone_name_servers" {
  value       = aws_route53_zone.private.name_servers
  description = "The name servers of the private hosted zone"
}

output "certificate_arn" {
  value = var.self_signed_cert == null ? aws_acm_certificate.private_ca_cert[0].arn : aws_acm_certificate.self_signed_cert[0].arn
  description = "The ARN of the created certificate"
}

output "certificate_authority_arn" {
  value       = var.self_signed_cert == null ? aws_acmpca_certificate_authority.ca[0].arn : null
  description = "The ARN of the private certificate authority (if created)"
}