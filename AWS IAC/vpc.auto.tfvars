# VPC Variables
vpc_name           = "Nuvei-cloud"
cidr_block         = "10.0.0.0/16"
domain             = "nuvei.com"
region             = "ca-central-1"
availability_zones = ["ca-central-1a", "ca-central-1b"]
public_subnet      = ["10.0.101.0/24", "10.0.102.0/24"]
private_subnet     = ["10.0.1.0/24", "10.0.2.0/24"]