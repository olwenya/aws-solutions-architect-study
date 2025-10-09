variable "subnet_public" {
  type     = string
  nullable = false
  default  = "172.31.1.0/24"
}

variable "availability_zone" {
  type     = string
  default  = "us-east-1a"
  nullable = false
}