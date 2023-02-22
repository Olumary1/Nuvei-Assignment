# Define Local Values in Terraform
# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.nuvei_vpc.id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.nuvei_vpc.cidr_block
}

# Elastic IP 
output "eip" {
  description = "Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.eip.public_ip
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.id
}
