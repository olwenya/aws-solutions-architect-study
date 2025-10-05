variable "vcp_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/16", "10.1.0.0/16"]
}
variable "subnet_private" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.1.1.0/24"]
}

variable "subnet_public" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.1.2.0/24"]
}

variable "vpc_names" {
  type    = list(string)
  default = ["einstein", "newton"]
}