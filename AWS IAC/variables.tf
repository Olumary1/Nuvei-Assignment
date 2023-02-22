# Input Variables

variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  #default = "ca-central-1"
}

variable "availability_zones" {
  description = "Region in which AWS Resources to be created"
  type        = list
}

variable "vpc_name" {
  description = "vpc cidr block"
  type        = string
}

variable "cidr_block" {
  description = "vpc cidr block"
  type        = string
}

variable "public_subnet" {
  description = "subnet cidr block"
  type        = list
}

variable "private_subnet" {
  description = "subnet cidr block"
  type        = list
}

variable "domain" {
  description = "Route53 Domain Name"
  type        = string
  #default = "nuvei.com"
}

variable "business_name" {
  description = "Business name of the organization"
  type        = string
  default     = "Nuvei"
}
