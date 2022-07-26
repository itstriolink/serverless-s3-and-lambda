/**
* Povio Terraform PS1
* Version 1.0
*/

output "vpc_id" {
    description = "VPC Id."
    value = aws_vpc.this.id
}

output "private_subnet_ids" {
    description = "List of private subnet Ids."
    value = aws_subnet.private.*.id
}

output "public_subnet_ids" {
    description = "List of public subnet Ids."
    value = aws_subnet.public.*.id
}
