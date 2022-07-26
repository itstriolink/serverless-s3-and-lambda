/**
* Povio Terraform RDS
* Version 2.0
*/

resource "aws_db_snapshot" "this" {
    count = var.rds_snapshot_instance_id == null ? 0 : 1

    db_instance_identifier = var.rds_snapshot_instance_id
    db_snapshot_identifier = "backup-${var.rds_snapshot_instance_id}-for-${var.rds_name}"

    tags = {
        Stage = var.stage_slug
    }
}
