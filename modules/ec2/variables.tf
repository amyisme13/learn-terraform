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
