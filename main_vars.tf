variable "app_env" {
  type        = string
  description = "The environment of the app"
  default     = "dev"
}

variable "instance_type" {
  type        = string
  description = "The ec2 instance type to use"
  default     = "t3.micro"
}
