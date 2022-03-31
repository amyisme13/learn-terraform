variable "infra_env" {
  type        = string
  description = "The environment of the infrastructure"
}

variable "instance_type" {
  type        = string
  description = "The ec2 instance type to use"
  default     = "db.t3.micro"
}

variable "security_groups" {
  type        = list(string)
  description = "A list of security group ids"
  default     = []
}

variable "subnets" {
  type        = list(string)
  description = "A list of subnet ids"
}

variable "default_db_name" {
  type        = string
  description = "The default database name"
  default     = "terra"
}

variable "master_username" {
  type        = string
  description = "The master username"
  default     = "admin"
}

variable "master_password" {
  type        = string
  description = "The master password"
}

variable "storage_size" {
  type        = number
  description = "The storage size"
  default     = 100
}

variable "max_storage_size" {
  type        = number
  description = "The maximum storage autoscaled size"
  default     = 1000
}
