/**
* Povio Terraform VPC
* Version 2.0
*/

#
# Public Tier
#

# Create public subnets for each AZ
resource "aws_subnet" "public" {
    count = var.aws_vpc_az_count

    cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, var.aws_vpc_az_count + count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id = aws_vpc.this.id
    map_public_ip_on_launch = true

    tags = {
        Stage = var.stage_slug
        Tier = "Public"
        Name = var.aws_vpc_name
    }
}

# IGW for the public subnet (attaches public IP)
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Stage = var.stage_slug
        Name = "${var.aws_vpc_name}-igw"
    }
}

# route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
    route_table_id = aws_vpc.this.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
}

