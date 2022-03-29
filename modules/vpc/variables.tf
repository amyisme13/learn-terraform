variable "infra_env" {
  type        = string
  description = "The environment of the infrastructure"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The IP range to be used for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "The availability zones used to generate subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "Subnets to be created for public traffic, one per az"
}

variable "private_subnets" {
  type        = list(string)
  description = "Subnets to be created for private traffic, one per az"
}
