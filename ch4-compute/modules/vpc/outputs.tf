output "subnet_id" {
    value = aws_subnet.subnet_public.id
}

output "vpc_id" {
    value  = data.aws_vpc.vpc_default.id
}