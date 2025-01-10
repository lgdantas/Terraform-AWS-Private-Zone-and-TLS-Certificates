# Required variables
vpc_id      = "vpc-xxxxxxxxxxxxxxxxx" # Replace with your VPC ID
domain_name = "sample.aws"            # Replace with your domain name

# Optional: Uncomment and modify if using self-signed certificates
# self_signed_cert = {
#  cert_file  = "cert/sample_pvtc.pem"
#  key_file   = "cert/sample_pvtk.pem"
#  chain_file = "cert/chain.pem"  # Optional
# }

# Optional: CA certificate details (used only if self_signed_cert is not provided)
ca_country             = "BR"
ca_organization        = "SAMPLE"
ca_organizational_unit = "IT"
ca_state               = "SP"
ca_locality            = "Sao Paulo"