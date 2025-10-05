variable "vpc_cidr" {
  type     = string
  nullable = false
}

variable "subnet_private" {
  type     = string
  nullable = false
}

variable "subnet_public" {
  type     = string
  nullable = false
}

variable "availability_zone" {
  type     = string
  nullable = false
}

variable "vpc_name" {
  type     = string
  nullable = false
}