output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for public_subnet in aws_subnet.public : public_subnet.id]
}

output "private_subnet_ids" {
  value = [for private_subnet in aws_subnet.private : private_subnet.id]
}