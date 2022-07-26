/**
* Povio Terraform RDS
* Version 2.0
*/

# create DB Subnet Group - placement in private/restricted subnet
resource "aws_db_subnet_group" "this" {
    name_prefix = "${var.rds_name}-rds"
    subnet_ids = var.db_subnet_group_subnet_ids

    tags = {
        Stage = var.stage_slug
    }
}
