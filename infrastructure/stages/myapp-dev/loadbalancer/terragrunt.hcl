# VPC

terraform {
    source = "../../..//modules/aws-ps1-ecs-loadbalancer"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    stage_slug = local.stage_vars.stage_slug
    name = local.stage_vars.stage_slug
    vpc_id = dependency.vpc.outputs.vpc_id
    aliases = ["api.${dependency.certificates.outputs.domain}"]
    # cf_aliases = ["api.${dependency.certificates.outputs.domain}"]
    cloudfront_certificate_arn = dependency.certificates.outputs.cert_arn
    public_subnet_ids = dependency.vpc.outputs.public_subnet_ids
    zone_id = dependency.certificates.outputs.zone_id
    # Example to add a s3 bucket to the api
    #static_endpoints = {
    #    s3-uploads = {
    #        origin_id = "${local.stage_vars.stage_slug}-s3-uploads"
    #        path = "/uploads/*",
    #        bucket_arn = dependency.s3-uploads.outputs.bucket_arn,
    #        bucket_id = dependency.s3-uploads.outputs.bucket_id,
    #        bucket_regional_domain_name = dependency.s3-uploads.outputs.bucket_regional_domain_name
    #    }
    #}
}

# s3 uploads
#dependency "s3-uploads" {
#    config_path = "../s3-uploads"
#}


# vpc
dependency "vpc" {
    config_path = "../vpc"
}

# domain certificate
dependency "certificates" {
    config_path = "../certificates"
}
