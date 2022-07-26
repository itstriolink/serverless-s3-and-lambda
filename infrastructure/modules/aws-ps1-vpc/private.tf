/**
* Povio Terraform VPC
* Version 2.0
*/

#
# Private Tier, with internet access
#

# Create private subnets for each AZ
resource "aws_subnet" "private" {
    count = var.aws_vpc_enable_private_subnet ? var.aws_vpc_az_count : 0

    cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id = aws_vpc.this.id
    map_public_ip_on_launch = false

    tags = {
        Stage = var.stage_slug
        Name = "${var.aws_vpc_name}-private-${count.index}"
        Tier = "Private"
    }
}

# create a NAT gateway with an EIP for each private subnet to get internet connectivity
resource "aws_eip" "this" {
    count = var.aws_vpc_enable_private_subnet ? var.aws_vpc_az_count : 0

    vpc = true
    depends_on = [
        aws_internet_gateway.this
    ]

    tags = {
        Stage = var.stage_slug
        Name = "${var.aws_vpc_name}-eip"
    }
}

resource "aws_nat_gateway" "this" {
    count = var.aws_vpc_enable_private_subnet ? var.aws_vpc_az_count : 0

    subnet_id = element(aws_subnet.public.*.id, count.index)
    allocation_id = element(aws_eip.this.*.id, count.index)

    tags = {
        Stage = var.stage_slug
        Name = "${var.aws_vpc_name}-nat"
    }
}

# Create a new route table for the private subnets
# And make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
    count = var.aws_vpc_enable_private_subnet ? var.aws_vpc_az_count : 0

    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
    }

    tags = {
        Stage = var.stage_slug
        Name = "${var.aws_vpc_name}-private"
    }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
    count = var.aws_vpc_enable_private_subnet ? var.aws_vpc_az_count : 0

    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}
