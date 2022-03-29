variable "infra_env" {
  type        = string
  description = "The environment of the infrastructure"
}

variable "infra_role" {
  type        = string
  description = "The role of the infrastructure"
}

variable "instance_type" {
  type        = string
  description = "The ec2 instance type to use"
  default     = "t3.micro"
}

variable "instance_ami" {
  type        = string
  description = "The AMI to use for the instance"
}

variable "instance_root_volume_size" {
  type        = number
  description = "The size of the root volume"
  default     = 20
}

variable "available_subnets" {
  type        = list(string)
  description = "The subnets available to be used for ec2"
}

variable "create_eip" {
  type        = bool
  description = "Whether to create an elastic IP address"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the ec2 instance"
  default     = {}
}
