variable "instance_type" {
  type     = string
  nullable = false
  default  = "t3.micro"
}

variable "ami_id" {
  type     = string
  nullable = false
  default  = "0360c520857e3138f"
}

variable "clustername" {
  type     = string
  nullable = false
  default  = "swarm"
}