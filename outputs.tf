# output "azs_info"{
#     value = data.aws_availability_zones.available.names
# }


output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}


output "public_subnet_ids"{
    value = aws_subnet.public[*].id
}

output "private_subnet_ids"{
    value = aws_subnet.private[*].id
}

output "database_subnet_ids"{
    value = aws_subnet.database[*].id
}