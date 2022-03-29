variable "infra_env" {
  type        = string
  description = "The environment of the infrastructure"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The IP range to be used for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_numbers" {
  type = map(number)

  description = "Map of AZ to a number that should be used for public subnets"

  default = {
    "ap-southeast-3a" = 1
    "ap-southeast-3b" = 2
    "ap-southeast-3c" = 3
  }
}

variable "private_subnet_numbers" {
  type = map(number)

  description = "Map of AZ to a number that should be used for private subnets"

  default = {
    "ap-southeast-3a" = 4
    "ap-southeast-3b" = 5
    "ap-southeast-3c" = 6
  }
}
