# VPC

terraform {
    source = "../../..//modules/aws-s3-private-bucket"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    bucket_name = "${local.stage_vars.stage_slug}-uploads"
    stage_slug = local.stage_vars.stage_slug
    enable_versioning = false
    enable_mfa_delete = false
    acceleration_status = "Suspended"
#    lifecycle_rules = {
#        expire_after_two_months = {
#            type = "expiration"
#            days = 60
#            abort_incomplete_multipart_upload_days = 1
#        }
#        transition_to_one_zone_IA_after_one_month = {
#            type = "transition"
#            days = 30
#            storage_class = "ONEZONE_IA"
#        }
#    }
}
