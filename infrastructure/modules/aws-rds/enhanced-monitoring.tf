/**
* Povio Terraform RDS
* Version 2.0
*/

data "aws_iam_policy_document" "rds_assume_role" {
    count = var.rds_monitoring_interval <= 0 ? 0 : 1

    statement {
        actions = [
            "sts:AssumeRole"
        ]

        principals {
            type        = "Service"
            identifiers = [
                "monitoring.rds.amazonaws.com"
            ]
        }
    }
}

resource "aws_iam_role" "this" {
    count = var.rds_monitoring_interval <= 0 ? 0 : 1

    name               = "${var.rds_name}-db-enhanced-monitoring-role"
    path               = "/"
    assume_role_policy = data.aws_iam_policy_document.rds_assume_role[0].json
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
    ]

    tags = {
        Stage = var.stage_slug
    }
}
